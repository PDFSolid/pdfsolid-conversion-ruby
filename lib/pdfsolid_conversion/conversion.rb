module PdfSolidConversion
  # Provides PDF conversion entry points backed by the native SDK.
  module Conversion
    module_function

    # Converts a PDF document to a Word DOCX file.
    # Returns an ErrorCode value.
    def start_pdf_to_word(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToWord, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to a Rich Text Format file.
    # Returns an ErrorCode value.
    def start_pdf_to_rtf(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToRtf, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to an Excel workbook.
    # Returns an ErrorCode value.
    def start_pdf_to_excel(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToExcel, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to a PowerPoint presentation.
    # Returns an ErrorCode value.
    def start_pdf_to_ppt(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToPpt, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to HTML output.
    # Returns an ErrorCode value.
    def start_pdf_to_html(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToHtml, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to image files.
    # Returns an ErrorCode value.
    def start_pdf_to_image(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToImage, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to a searchable PDF.
    # Returns an ErrorCode value.
    def start_pdf_to_searchable_pdf(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToSearchablePDF, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to plain text.
    # Returns an ErrorCode value.
    def start_pdf_to_txt(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToTxt, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to structured JSON output.
    # Returns an ErrorCode value.
    def start_pdf_to_json(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToJson, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to Markdown output.
    # Returns an ErrorCode value.
    def start_pdf_to_markdown(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToMarkdown, file_path, password, output_path, options, callback)
    end

    # Converts a PDF document to OFD output.
    # Returns an ErrorCode value.
    def start_pdf_to_ofd(file_path, password, output_path, options = ConvertOptions.new, callback: nil)
      call_conversion(:CPDF_Ruby_StartPDFToOfd, file_path, password, output_path, options, callback)
    end

    # Dispatches a conversion request to the selected native SDK function.
    def call_conversion(native_method, file_path, password, output_path, options, callback)
      native_options = options.to_native
      native_callback = callback ? callback.to_native : 0
      Native.public_send(native_method, file_path.to_s, password.to_s, output_path.to_s, native_options, native_callback)
    end
  end
end