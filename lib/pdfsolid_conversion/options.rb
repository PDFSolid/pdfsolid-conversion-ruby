require "fiddle"

module PdfSolidConversion
  # Stores conversion settings passed to native conversion APIs.
  # Word to PDF reads only page_ranges and word_pdf_bookmark_mode; the other
  # settings do not apply to it.
  class ConvertOptions
    # sizeof(CConvertOption) on x86_64, including 4 trailing padding bytes.
    OPTION_STRUCT_SIZE = 592
    STRING_BUFFER_SIZE = 256
    MAX_LANGUAGES = 32

    # Whether to enable AI layout analysis during conversion.
    attr_accessor :enable_ai_layout,
                  :enable_ai_table_recognition,
                  :table_recognition_accuracy,
                  :contain_image,
                  :contain_page_background_image,
                  :json_contain_table,
                  :contain_annotation,
                  :excel_all_content,
                  :excel_csv_format,
                  :enable_ocr,
                  :enable_document_orientation_classification,
                  :enable_document_dewarp,
                  :enable_auto_page_size,
                  :custom_page_width,
                  :custom_page_height,
                  :transparent_text,
                  :txt_table_format,
                  :image_path_enhance,
                  :formula_to_image,
                  :auto_create_folder,
                  :output_document_per_page,
                  :image_scaling,
                  :page_layout_mode,
                  :excel_worksheet_option,
                  :html_option,
                  :ocr_option,
                  :image_color_mode,
                  :image_type,
                  :font_name,
                  :page_ranges,
                  :languages,
                  # How the PDF bookmarks are generated. Only takes effect for Word to PDF.
                  :word_pdf_bookmark_mode

            # Creates conversion options with SDK default values.
    def initialize
      @enable_ai_layout = true
      @enable_ai_table_recognition = true
      @table_recognition_accuracy = TableRecognitionAccuracy::BALANCED
      @contain_image = true
      @contain_page_background_image = true
      @json_contain_table = true
      @contain_annotation = true
      @excel_all_content = false
      @excel_csv_format = false
      @enable_ocr = false
      @enable_document_orientation_classification = false
      @enable_document_dewarp = false
      @enable_auto_page_size = false
      @custom_page_width = 0.0
      @custom_page_height = 0.0
      @transparent_text = false
      @txt_table_format = true
      @image_path_enhance = false
      @formula_to_image = true
      @auto_create_folder = true
      @output_document_per_page = false
      @image_scaling = 1.0
      @page_layout_mode = PageLayoutMode::FLOW
      @excel_worksheet_option = ExcelWorksheetOption::FOR_TABLE
      @html_option = HtmlOption::SINGLE_PAGE
      @ocr_option = OCROption::ALL
      @image_color_mode = ImageColorMode::COLOR
      @image_type = ImageType::JPG
      @font_name = ""
      @page_ranges = ""
      @languages = []
      @word_pdf_bookmark_mode = WordPdfBookmarkMode::NONE
    end

    # Converts Ruby option values into the native option structure.
    def to_native
      language_values = Array(@languages).first(MAX_LANGUAGES).map(&:to_i)
      @languages_pointer = nil
      language_pointer_value = 0

      unless language_values.empty?
        @languages_pointer = Fiddle::Pointer.malloc(language_values.length * 4)
        @languages_pointer[0, language_values.length * 4] = language_values.pack("i*")
        language_pointer_value = @languages_pointer.to_i
      end

      packed = [
        bool(@enable_ai_layout),
        bool(@enable_ai_table_recognition),
        bool(@contain_image),
        bool(@contain_page_background_image),
        bool(@json_contain_table),
        bool(@contain_annotation),
        bool(@excel_all_content),
        bool(@excel_csv_format),
        bool(@enable_ocr),
        bool(@transparent_text),
        bool(@txt_table_format),
        bool(@image_path_enhance),
        bool(@formula_to_image),
        bool(@auto_create_folder),
        bool(@output_document_per_page),
        language_values.length,
        @image_scaling.to_f,
        @page_layout_mode.to_i,
        @excel_worksheet_option.to_i,
        @html_option.to_i,
        @ocr_option.to_i,
        @image_color_mode.to_i,
        @image_type.to_i,
        fixed_string(@font_name),
        fixed_string(@page_ranges),
        language_pointer_value,
        bool(@enable_document_orientation_classification),
        bool(@enable_document_dewarp),
        bool(@enable_auto_page_size),
        @custom_page_width.to_f,
        @custom_page_height.to_f,
        @table_recognition_accuracy.to_i,
        @word_pdf_bookmark_mode.to_i
      ].pack("C15xifiiiiiia256a256JC3xffiix4")

      pointer = Fiddle::Pointer.malloc(OPTION_STRUCT_SIZE)
      pointer[0, OPTION_STRUCT_SIZE] = packed
      pointer
    end

    private

    def bool(value)
      value ? 1 : 0
    end

    def fixed_string(value)
      value.to_s.byteslice(0, STRING_BUFFER_SIZE - 1).to_s
    end
  end
end
