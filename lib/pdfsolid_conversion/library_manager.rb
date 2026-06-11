module PdfSolidConversion
  # Provides lifecycle and utility APIs for the native PdfSolid Conversion SDK.
  module LibraryManager
    module_function

    # Verifies the SDK license with a device ID and application ID.
    # Returns an ErrorCode value.
    def license_verify(license, device_id, app_id)
      Native.CPDF_Ruby_LicenseVerify(license.to_s, device_id.to_s, app_id.to_s)
    end

    # Initializes the native SDK. Pass a resource directory when font resources are needed.
    def initialize_sdk(resource_path = "")
      path = resource_path.to_s
      unless path.empty?
        path = File.expand_path(path)
        fonts_path = File.join(path, "fonts")
        unless File.directory?(fonts_path)
          raise ArgumentError, "SDK resource fonts directory not found: #{fonts_path}"
        end
      end

      Native.CPDF_Ruby_Initialize(path)
      nil
    end

    # Enables or disables native SDK info and warning logs.
    def set_logger(enable_info, enable_warning)
      Native.CPDF_SetLogger(enable_info ? 1 : 0, enable_warning ? 1 : 0)
      nil
    end

    # Loads the DocumentAI model used by OCR, layout analysis, and table recognition.
    # Returns an ErrorCode value.
    def set_document_ai_model(model_path, gpu_id = -1)
      Native.CPDF_Ruby_SetDocumentAIModel(model_path.to_s, gpu_id.to_i)
    end

    # Returns the page count of a PDF document.
    def page_count(file_path, password = "")
      Native.CPDF_Ruby_GetPageCount(file_path.to_s, password.to_s)
    end

    # Returns the remaining licensed page quota.
    def remaining_page_quota
      Native.CPDF_GetRemainingPageQuota()
    end

    # Returns the native SDK version string.
    def version
      buffer = "\0" * 64
      Native.CPDF_GetVersion(buffer)
      buffer.delete("\0")
    end

    # Releases resources held by the native SDK.
    def release
      Native.CPDF_Release()
      nil
    end

    # Releases the currently loaded DocumentAI model.
    def release_document_ai_model
      Native.CPDF_ReleaseDocumentAIModel()
      nil
    end

    # Sets the number of DocumentAI layout and table model instances.
    def set_document_ai_model_count(layout_model_count, table_model_count)
      Native.CPDF_SetDocumentAIModelCount(layout_model_count.to_i, table_model_count.to_i)
      nil
    end
  end
end