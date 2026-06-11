module PdfSolidConversion
  # OCR language constants used by ConvertOptions#languages.
  module OCRLanguage
    UNKNOWN = 0
    CHINESE = 1
    CHINESE_TRA = 2
    ENGLISH = 3
    KOREAN = 4
    JAPANESE = 5
    LATIN = 6
    DEVANAGARI = 7
    CYRILLIC = 8
    ARABIC = 9
    TAMIL = 10
    TELUGU = 11
    KANNADA = 12
    THAI = 13
    GREEK = 14
    ESLAV = 15
    AUTO = 16
  end

  # Layout reconstruction modes used by ConvertOptions#page_layout_mode.
  module PageLayoutMode
    BOX = 0
    FLOW = 1
  end

  # OCR processing scope used by ConvertOptions#ocr_option.
  module OCROption
    INVALID_CHARACTER = 0
    SCAN_PAGE = 1
    INVALID_CHARACTER_AND_SCAN_PAGE = 2
    ALL = 3
  end

  # Image color modes used by ConvertOptions#image_color_mode.
  module ImageColorMode
    COLOR = 0
    GRAY = 1
    BINARY = 2
  end

  # Image output format constants used by ConvertOptions#image_type.
  module ImageType
    JPG = 0
    JPEG = 1
    JPEG2000 = 2
    PNG = 3
    BMP = 4
    TIFF = 5
    TGA = 6
    GIF = 7
    WEBP = 8
  end

  # Excel worksheet layout constants used by ConvertOptions#excel_worksheet_option.
  module ExcelWorksheetOption
    FOR_TABLE = 0
    FOR_PAGE = 1
    FOR_DOCUMENT = 2
  end

  # HTML output mode constants used by ConvertOptions#html_option.
  module HtmlOption
    SINGLE_PAGE = 0
    SINGLE_PAGE_WITH_BOOKMARK = 1
    MULTI_PAGE = 2
    MULTI_PAGE_WITH_BOOKMARK = 3
  end
end