require "fiddle"
require "fiddle/import"
require "rbconfig"

module PdfSolidConversion
  # Loads packaged native libraries and exposes low-level C API bindings.
  module Native
    extend Fiddle::Importer

    def self.platform_dir
      host_os = RbConfig::CONFIG["host_os"]
      host_cpu = RbConfig::CONFIG["host_cpu"]
      unless host_cpu =~ /(x86_64|amd64|x64)/i
        raise LoadError, "PdfSolidConversion Ruby SDK currently packages x86_64 native libraries only: #{host_cpu}"
      end

      case host_os
      when /linux/i
        "linux-x86_64"
      when /mswin|mingw|cygwin/i
        "windows-x86_64"
      else
        raise LoadError, "PdfSolidConversion Ruby SDK currently supports Linux x86_64 and Windows x86_64 only: #{host_os}"
      end
    end

    def self.library_names
      case platform_dir
      when "linux-x86_64"
        [
          "libonnxruntime.so.1.18.0",
          "libopencv_world.so.410",
          "libDocumentAI.so.4.0.0",
          "libpdfsolidconversionsdk.so",
          "libpdfsolidconversion_ruby_bridge.so"
        ]
      when "windows-x86_64"
        [
          "onnxruntime.dll",
          "onnxruntime_providers_shared.dll",
          "opencv_world4100.dll",
          "DocumentAI.dll",
          "pdfsolidconversionsdk.dll",
          "pdfsolidconversion_ruby_bridge.dll"
        ]
      else
        raise LoadError, "unsupported native platform: #{platform_dir}"
      end
    end

    PLATFORM_DIR = platform_dir
    VENDOR_DIR = File.expand_path(File.join(__dir__, "vendor", PLATFORM_DIR))
    FLAT_RUNTIME_DIR = File.expand_path("..", __dir__)

    def self.runtime_dir
      candidates = [VENDOR_DIR, FLAT_RUNTIME_DIR]
      candidates.find do |dir|
        library_names.all? { |name| File.file?(File.join(dir, name)) }
      end || VENDOR_DIR
    end

    # Returns native library paths in dependency loading order.
    def self.load_paths
      selected_runtime_dir = runtime_dir
      required = library_names.map { |name| File.join(selected_runtime_dir, name) }

      missing = required.reject { |path| File.file?(path) }
      unless missing.empty?
        raise LoadError, "native libraries are missing; run pdfsolid_sdk/ruby/scripts/build_linux_package.sh first: #{missing.join(', ')}"
      end

      required
    end

    load_paths.each do |path|
      Fiddle::Handle.new(path, Fiddle::RTLD_NOW | Fiddle::RTLD_GLOBAL)
    end

    dlload(*load_paths)

    extern "int CPDF_Ruby_LicenseVerify(char*, char*, char*)"
    extern "void CPDF_Ruby_Initialize(char*)"
    extern "void CPDF_SetLogger(int, int)"
    extern "int CPDF_Ruby_SetDocumentAIModel(char*, int)"
    extern "int CPDF_Ruby_GetPageCount(char*, char*)"
    extern "int CPDF_GetRemainingPageQuota()"
    extern "void CPDF_GetVersion(char*)"
    extern "void CPDF_Release()"
    extern "void CPDF_ReleaseDocumentAIModel()"
    extern "void CPDF_SetDocumentAIModelCount(int, int)"

    extern "int CPDF_Ruby_StartPDFToWord(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToRtf(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToExcel(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToPpt(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToHtml(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToImage(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToSearchablePDF(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToTxt(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToJson(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToMarkdown(char*, char*, char*, void*, void*)"
    extern "int CPDF_Ruby_StartPDFToOfd(char*, char*, char*, void*, void*)"
  end
end