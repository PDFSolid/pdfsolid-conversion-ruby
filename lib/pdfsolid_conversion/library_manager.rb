module PdfSolidConversion
  # Provides lifecycle and utility APIs for the native Conversion SDK.
  module LibraryManager
    module_function

    # Verifies a license string or license XML file path with the required device/application
    # IDs. Pass samples/license.xml directly; do not extract its key. Returns an ErrorCode
    # value; 0 means success.
    def license_verify(license, device_id, app_id)
      Native.CPDF_Ruby_LicenseVerify(license.to_s, device_id.to_s, app_id.to_s)
    end

    # Initializes the native SDK after successful license verification. Use the default empty
    # path for the Linux delivery: the core uses system fonts and models load separately. A
    # nonempty custom path still requires a fonts/ subdirectory for the binding's legacy
    # validation.
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

    # Loads one DocumentAI package incrementally after initialization and while idle. Each
    # successful call merges capabilities in any order; a failed load preserves previously
    # loaded capabilities. Use SDK-matching base and extension packages. Returns an ErrorCode
    # value (0 on success, 60 when converting or releasing); check each result. GPU ID -1
    # selects CPU execution.
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

    # Returns the type of the currently verified license (a LicenseType value)
    # without verifying again or consuming page quota.
    def license_type
      Native.CPDF_GetLicenseType()
    end

    # Returns the native SDK version string.
    def version
      buffer = "\0" * 64
      Native.CPDF_GetVersion(buffer)
      buffer.delete("\0")
    end

    # Releases resources held by the native SDK after all synchronous conversions finish.
    def release
      Native.CPDF_Release()
      nil
    end

    # Releases all loaded DocumentAI model packages after all conversion calls finish. Load
    # the packages again before using AI features.
    def release_document_ai_model
      Native.CPDF_ReleaseDocumentAIModel()
      nil
    end

    # Sets the number of DocumentAI layout and table model instances while the SDK is idle.
    def set_document_ai_model_count(layout_model_count, table_model_count)
      Native.CPDF_SetDocumentAIModelCount(layout_model_count.to_i, table_model_count.to_i)
      nil
    end
  end
end
