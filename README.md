# PDFSolid Conversion SDK for Ruby

High-performance Ruby SDK for converting PDF to Word, Excel, PowerPoint, HTML, Image, TXT, RTF, CSV, JSON, Markdown, Searchable PDF, and OFD with AI-powered OCR, layout analysis, and table recognition.

## Features

- **PDF to Word** (.docx) — Flow and Box layout modes
- **PDF to Excel** (.xlsx) — per-table, per-page, or per-document worksheet options
- **PDF to PowerPoint** (.pptx)
- **PDF to HTML** (.html) — single/multi-page with optional bookmark navigation
- **PDF to CSV** (.csv)
- **PDF to Image** (.png, .jpg, .jpeg, .jpeg2000, .bmp, .tiff, .tga, .gif, .webp) — color/grayscale/binary, configurable scaling
- **PDF to Plain Text** (.txt) — optional table format preservation
- **PDF to RTF** (.rtf)
- **PDF to Searchable PDF** (.pdf) — OCR with transparent text layer
- **PDF to OFD** (.ofd) — OCR, page background preservation, transparent text layer
- **PDF to JSON** (.json) — structured data with table extraction
- **PDF to Markdown** (.md)

### AI-Powered Document Tools

- **OCR** — Optical Character Recognition for scanned documents and images
- **Layout Analysis** — AI-based document structure parsing
- **Table Recognition** — AI-based table structure reconstruction
- **Custom AI Models** — plug in your own OCR, layout, or table engine via callbacks (SDK v1.1.0+)

## Requirements

| Platform | System Requirements | Development Environment |
| -------- | ------------------- | ----------------------- |
| Linux | Linux x86_64 | Ruby 2.7+ |

## Quick Start

### 1. Get a License

Contact [sales@pdfsolid.com](mailto:sales@pdfsolid.com) for a 30-day free trial or commercial license.

### 2. Apply License and Initialize

```ruby
require "pdfsolid_conversion"

code = PdfSolidConversion::LibraryManager.license_verify("LICENSE_KEY", "DEVICE_ID", "com.example.application")
raise "license verification failed: #{code}" unless code == PdfSolidConversion::ErrorCode::SUCCESS

PdfSolidConversion::LibraryManager.initialize_sdk
```

### 3. Convert

```ruby
options = PdfSolidConversion::ConvertOptions.new
PdfSolidConversion::Conversion.start_pdf_to_word("input.pdf", "", "output.docx", options)
```

### Release Resources

```ruby
PdfSolidConversion::LibraryManager.release_document_ai_model
PdfSolidConversion::LibraryManager.release
```

## Conversion Examples

### PDF to Excel

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.excel_worksheet_option = PdfSolidConversion::ExcelWorksheetOption::FOR_TABLE
PdfSolidConversion::Conversion.start_pdf_to_excel("input.pdf", "", "output.xlsx", options)
```

### PDF to Image

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.image_type = PdfSolidConversion::ImageType::PNG
options.image_scaling = 2.0
PdfSolidConversion::Conversion.start_pdf_to_image("input.pdf", "", "output", options)
```

### PDF to Searchable PDF (OCR)

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
options.transparent_text = true
PdfSolidConversion::Conversion.start_pdf_to_searchable_pdf("scan.pdf", "", "output.pdf", options)
```

### PDF to JSON with Table Extraction

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.json_contain_table = true
PdfSolidConversion::Conversion.start_pdf_to_json("input.pdf", "", "output.json", options)
```

### Custom AI Engine (SDK v1.1.0+)

```ruby
callback = PdfSolidConversion::ConvertCallback.new
callback.on_ocr = ->(image_path) { run_my_ocr_model(image_path) }
callback.get_ocr_result = -> { @ocr_json_result }

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
PdfSolidConversion::Conversion.start_pdf_to_word("input.pdf", "", "output.docx", options, callback)
```

## Documentation

- [Developer Guide](doc/developer_guide_ruby.md)
- [API Reference](doc/api_reference_ruby.html)

## Contact

- Website: [https://www.pdfsolid.com](https://www.pdfsolid.com/)
- Sales: [sales@pdfsolid.com](mailto:sales@pdfsolid.com)
- Support: [support@pdfsolid.com](mailto:support@pdfsolid.com)
