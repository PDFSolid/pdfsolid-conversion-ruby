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
        raise LoadError, "PDFSolid Conversion SDK for Ruby currently packages x86_64 native libraries only: #{host_cpu}"
      end

      case host_os
      when /linux/i
        "linux-x86_64"
      when /mswin|mingw|cygwin/i
        "windows-x86_64"
      else
        raise LoadError, "PDFSolid Conversion SDK for Ruby currently supports Linux x86_64 and Windows x86_64 only: #{host_os}"
      end
    end

    def self.native_sdk_library_name
      if ENV["CONVERSION_RUBY_NATIVE_SDK_FILE"] && !ENV["CONVERSION_RUBY_NATIVE_SDK_FILE"].empty?
        return ENV["CONVERSION_RUBY_NATIVE_SDK_FILE"]
      end

      if ENV["CONVERSION_RUBY_NATIVE_SDK_NAME"] && !ENV["CONVERSION_RUBY_NATIVE_SDK_NAME"].empty?
        return platform_dir == "windows-x86_64" ? "#{ENV["CONVERSION_RUBY_NATIVE_SDK_NAME"]}.dll" : "lib#{ENV["CONVERSION_RUBY_NATIVE_SDK_NAME"]}.so"
      end

      default_name = platform_dir == "windows-x86_64" ? "pdfsolidconversionsdk.dll" : "libpdfsolidconversionsdk.so"
      runtime = platform_dir == "windows-x86_64" ? WINDOWS_RUNTIME_DIR : LINUX_RUNTIME_DIR
      return default_name if File.file?(File.join(runtime, default_name))
      return default_name unless Dir.exist?(runtime)

      pattern = platform_dir == "windows-x86_64" ? /\A[A-Za-z0-9_]+conversionsdk\.dll\z/i : /\Alib[A-Za-z0-9_]+conversionsdk\.so\z/
      Dir.children(runtime).grep(pattern).sort.first || default_name
    end

    def self.library_names
      case platform_dir
      when "linux-x86_64"
        [
          "libonnxruntime.so.1",
          "libopencv_world.so.410",
          "libDocumentAI.so.4.3.0",
          native_sdk_library_name,
          "libpdfsolid_ruby_bridge.so"
        ]
      when "windows-x86_64"
        [
          "onnxruntime.dll",
          "onnxruntime_providers_shared.dll",
          "opencv_world4100.dll",
          "DocumentAI.dll",
          native_sdk_library_name,
          "pdfsolid_ruby_bridge.dll"
        ]
      else
        raise LoadError, "unsupported native platform: #{platform_dir}"
      end
    end

    PLATFORM_DIR = platform_dir
    LINUX_RUNTIME_DIR = File.expand_path("..", __dir__)
    WINDOWS_RUNTIME_DIR = File.expand_path(File.join("..", "windows-x86_64"), __dir__)

    def self.runtime_dir
      candidates = platform_dir == "windows-x86_64" ? [WINDOWS_RUNTIME_DIR] : [LINUX_RUNTIME_DIR]
      candidates.find do |dir|
        library_names.all? { |name| File.file?(File.join(dir, name)) }
      end || candidates.first
    end

    # Returns native library paths in dependency loading order.
    def self.load_paths
      selected_runtime_dir = runtime_dir
      required = library_names.map { |name| File.join(selected_runtime_dir, name) }

      missing = required.reject { |path| File.file?(path) }
      unless missing.empty?
        raise LoadError, "native libraries are missing; run scripts/build_linux_package.sh first: #{missing.join(', ')}"
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
    extern "int CPDF_GetLicenseType()"
    extern "void CPDF_GetVersion(char*)"
    extern "void CPDF_Release()"
    extern "void CPDF_ReleaseDocumentAIModel()"
    extern "void CPDF_SetDocumentAIModelCount(int, int)"

    extern "int CPDF_Ruby_StartWordToPDF(char*, char*, void*, void*)"
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
