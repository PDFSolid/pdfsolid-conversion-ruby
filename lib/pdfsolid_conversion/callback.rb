require "fiddle"

module PdfSolidConversion
  # Wraps Ruby progress and cancel callbacks for native conversion APIs.
  class ConvertCallback
    CALLBACK_STRUCT_SIZE = Fiddle::SIZEOF_VOIDP * 9

    # Creates a callback wrapper.
    # progress receives current_page and total_page.
    # cancel returns true to cancel the current conversion task.
    def initialize(progress: nil, cancel: nil)
      @progress_proc = progress
      @cancel_proc = cancel
      @closures = []
    end

    # Converts Ruby callbacks into the native callback structure.
    def to_native
      progress_pointer = 0
      cancel_pointer = 0

      if @progress_proc
        progress_closure = Fiddle::Closure::BlockCaller.new(
          Fiddle::TYPE_VOID,
          [Fiddle::TYPE_INT, Fiddle::TYPE_INT]
        ) do |current_page, total_page|
          @progress_proc.call(current_page, total_page)
        end
        @closures << progress_closure
        progress_pointer = progress_closure.to_i
      end

      if @cancel_proc
        cancel_closure = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, []) do
          @cancel_proc.call ? 1 : 0
        end
        @closures << cancel_closure
        cancel_pointer = cancel_closure.to_i
      end

      values = [0, cancel_pointer, progress_pointer, 0, 0, 0, 0, 0, 0]
      pointer = Fiddle::Pointer.malloc(CALLBACK_STRUCT_SIZE)
      pointer[0, CALLBACK_STRUCT_SIZE] = values.pack("J*")
      pointer
    end
  end
end