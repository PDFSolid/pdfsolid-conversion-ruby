# PDFSolid Conversion SDK for Ruby

PDFSolid Conversion SDK is a high-performance library designed for extracting and transforming the data within your PDF files, such as text, images, tables, links, and annotations, into various file formats. The Conversion SDK retains the original document layout and the properties of the file data, helping you build a reliable document conversion workflow in Ruby applications.

## Supported Conversions

- Convert PDF to Word (.docx)
- Convert PDF to Excel (.xlsx)
- Convert PDF to PowerPoint (.pptx)
- Convert PDF to HTML (.html)
- Convert PDF to CSV (.csv)
- Convert PDF to Image (.png, .jpg, .jpeg, .jpeg2000, .bmp, .tiff, .tga, .gif, .webp)
- Convert PDF to Plain Text (.txt)
- Convert PDF to Rich Text Format (.rtf)
- Convert PDF to Searchable PDF (.pdf)
- Convert PDF to OFD (.ofd)
- Convert PDF to Structured Data (.json)
- Convert PDF to Markdown (.md)

## AI-Powered Document Tools

- Optical Character Recognition (OCR)
- Layout Analysis
- Table Recognition

## Requirements

| Platform | System Requirements | Development Environment |
| -------- | ------------------- | ----------------------- |
| Linux | Linux x86_64 | Ruby 2.7 or higher |

The Ruby SDK does not require third-party Ruby gems at runtime. It uses Ruby standard libraries, including `Fiddle`, `FileUtils`, `OptionParser`, and `Thread`.

## Quick Start

### 1. Install the SDK

Contact sales@pdfsolid.com to obtain the PDFSolid Conversion SDK for Ruby.

### 2. Apply License

```ruby
require "pdfsolid_conversion"

code = PdfSolidConversion::LibraryManager.license_verify("LICENSE_KEY", "DEVICE_ID", "com.example.application")
raise "license verification failed: #{code}" unless code == PdfSolidConversion::ErrorCode::SUCCESS

PdfSolidConversion::LibraryManager.initialize_sdk
```

### 3. Convert PDF to Word

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.page_layout_mode = PdfSolidConversion::PageLayoutMode::FLOW

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  "input.pdf",
  "",
  "output.docx",
  options
)
```

### 4. Convert PDF to Excel

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.excel_worksheet_option = PdfSolidConversion::ExcelWorksheetOption::FOR_TABLE

result = PdfSolidConversion::Conversion.start_pdf_to_excel(
  "input.pdf",
  "",
  "output.xlsx",
  options
)
```

### 5. Convert PDF to Image

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.image_type = PdfSolidConversion::ImageType::PNG
options.image_scaling = 2.0

result = PdfSolidConversion::Conversion.start_pdf_to_image(
  "input.pdf",
  "",
  "output",
  options
)
```

### 6. OCR Conversion

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  "scan.pdf",
  "",
  "output.docx",
  options
)
```

### 7. Release Resources

```ruby
PdfSolidConversion::LibraryManager.release_document_ai_model
PdfSolidConversion::LibraryManager.release
```

## Running the Demo

The SDK package includes a demo script at `samples/demo/demo.rb`:

```shell
cd /path/to/linux-x86_64
ruby samples/demo/demo.rb
```

With custom inputs:

```shell
ruby samples/demo/demo.rb \
  --output /tmp/pdfsolid_ruby_demo_out \
  /path/to/input.pdf
```

With license and multi-threading:

```shell
ruby samples/demo/demo.rb \
  --license /path/to/license.xml \
  --output /tmp/pdfsolid_ruby_demo_out \
  --threads 2 \
  samples/input_files/word.pdf \
  samples/input_files/excel.pdf
```

## Key Features

### Conversion Options

- **Contain Image & Annotation**: Control whether images and annotations are included in output.
- **Page Layout Mode**: Choose between Flow Layout (flexible, editable) and Box Layout (precise coordinate-based).
- **Page Range**: Convert specific pages or the entire document.
- **Output Font**: Set preferred font for output documents.
- **Formula to Image**: Convert formulas to images for visual consistency.

### OCR Support

Supports 15+ languages including Chinese, English, Korean, Japanese, Latin, Devanagari, Cyrillic, Arabic, and more. OCR options include:

- `INVALID_CHARACTER`: OCR for garbled/invalid characters only.
- `SCAN_PAGE`: OCR for scanned pages only.
- `INVALID_CHARACTER_AND_SCAN_PAGE`: Both of the above.
- `ALL`: OCR for all pages and characters.

### AI-Powered Features

- **Layout Analysis**: AI-based document structure detection for paragraphs, titles, figures, tables, headers, footers, and more.
- **Table Recognition**: Reconstructs table structure including merged cells, spanning cells, and borderless tables.
- **Custom AI Models (SDK v1.1.0+)**: Plug in your own AI inference engine via callbacks at the native C/C++ layer.

### Supported Image Formats

JPG, JPEG, JPEG2000, PNG, BMP, TIFF, TGA, GIF, WEBP with configurable color modes (Color, Gray, Binary) and scaling.

## Documentation

- [Developer Guide](doc/developer_guide_ruby.md) - Detailed usage instructions and API examples
- [API Reference](doc/api_reference_ruby.html) - Complete API reference

## License

PDFSolid Conversion SDK is a commercial SDK. Contact sales@pdfsolid.com for licensing information.

- Free 30-day trial license available upon request.
- Commercial licenses are bound to developer device ID.

## Contact

- Website: [https://www.pdfsolid.com](https://www.pdfsolid.com/)
- Sales: sales@pdfsolid.com
- Support: [support@pdfsolid.com](mailto:support@pdfsolid.com)
