require "fiddle"

module PdfSolidConversion
  # Wraps synchronous progress, cancellation, and custom AI callbacks.
  class ConvertCallback
    CALLBACK_STRUCT_SIZE = Fiddle::SIZEOF_VOIDP * 9

    # AI callbacks must be supplied as trigger/result pairs. Each trigger receives
    # a UTF-8 image path and returns true on success. Its result callback returns
    # SDK-compatible JSON (String), or nil on failure.
    def initialize(progress: nil, cancel: nil, on_ocr: nil, on_ocr_result: nil,
                   on_layout: nil, on_layout_result: nil, on_table: nil, on_table_result: nil)
      @callbacks = [cancel, progress, on_ocr, on_layout, on_table,
                    on_ocr_result, on_layout_result, on_table_result]
      @callbacks.compact.each do |callback|
        raise ArgumentError, "callbacks must respond to call" unless callback.respond_to?(:call)
      end
      [2, 3, 4].each do |index|
        if @callbacks[index].nil? != @callbacks[index + 3].nil?
          raise ArgumentError, "custom AI callbacks require both trigger and result"
        end
      end
    end

    # Each pointer owns its closures and result buffers, including for nested calls.
    # Keep it alive until the native conversion returns.
    def to_native
      state = NativeCallbacks.new(@callbacks)
      state.pointer.instance_variable_set(:@callback_state, state)
      state.pointer
    end

    # Defers callback exceptions until the native stack has unwound.
    def with_native # :nodoc:
      pointer = to_native
      result = yield pointer
      error = pointer.instance_variable_get(:@callback_state).error
      raise error if error
      result
    end

    class NativeCallbacks # :nodoc:
      attr_reader :pointer, :error

      def initialize(callbacks)
        @error = nil
        @closures = []
        @buffers = {}
        values = [0]
        callbacks.each_with_index do |callback, index|
          # Always provide cancellation so a callback exception can stop the SDK.
          values << ((callback || index == 0) ? bind(callback, index) : 0)
        end
        @pointer = Fiddle::Pointer.malloc(CALLBACK_STRUCT_SIZE, Fiddle::RUBY_FREE)
        @pointer[0, CALLBACK_STRUCT_SIZE] = values.pack("J*")
      end

      private

      def bind(callback, index)
        return_type = index == 1 ? Fiddle::TYPE_VOID : (index >= 5 ? Fiddle::TYPE_VOIDP : Fiddle::TYPE_CHAR)
        arguments = index == 1 ? [Fiddle::TYPE_INT, Fiddle::TYPE_INT] : (index >= 2 && index <= 4 ? [Fiddle::TYPE_VOIDP] : [])
        closure = Fiddle::Closure::BlockCaller.new(return_type, arguments) do |*args|
          invoke(callback, index, args)
        end
        @closures << closure
        closure.to_i
      end

      def invoke(callback, index, args)
        return index == 0 ? 1 : 0 if @error
        if index >= 2 && index <= 4
          args = [args.first.to_s.force_encoding(Encoding::UTF_8)]
        end
        value = callback ? callback.call(*args) : false
        return result_pointer(index, value) if index >= 5
        return 0 if index == 1
        unless value == true || value == false
          raise TypeError, "cancel and AI trigger callbacks must return true or false"
        end
        value ? 1 : 0
      rescue Exception => exception # Never unwind Ruby exceptions through native SDK frames.
        @error ||= exception
        index == 0 ? 1 : 0
      end

      def result_pointer(index, value)
        @buffers.delete(index)
        return 0 if value.nil?
        raise TypeError, "AI result callback must return a String or nil" unless value.is_a?(String)
        json = value.encode(Encoding::UTF_8)
        raise ArgumentError, "AI result must not contain NUL bytes" if json.include?("\0")
        buffer = Fiddle::Pointer.malloc(json.bytesize + 1, Fiddle::RUBY_FREE)
        buffer[0, json.bytesize + 1] = json + "\0"
        @buffers[index] = buffer
        buffer.to_i
      end
    end
    private_constant :NativeCallbacks
  end
end
