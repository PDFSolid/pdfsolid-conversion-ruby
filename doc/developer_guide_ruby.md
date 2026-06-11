# 1. Overview

PDFSolid Conversion SDK is a high-performance library designed for extracting and transforming the data within your PDF files, such as text, images, tables, links, and annotations, into various file formats. The Conversion SDK retains the original document layout and the properties of the file data, helping you build a reliable document conversion workflow in Ruby applications.

Effortlessly integrate the PDFSolid Conversion SDK into your Ruby projects in just a few steps, and enable the following file format conversions:

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

To enhance format conversion results, PDFSolid also provides AI-powered document tools with the following capabilities:

- Optical Character Recognition (OCR)
- Layout Analysis
- Table Recognition

## 1.1 Why PDFSolid Conversion SDK

- Mature Technology

  With years of technology accumulation, PDFSolid has established a complete mechanism of product iteration to offer a continuous guarantee for product competitiveness.

- Complete PDF and Format Conversion Functionalities

  The comprehensive feature set can meet diverse conversion needs and is easy for customers to use without training costs.

- High-quality Service

  Professional service and technical support can quickly respond to users' feedback through onsite service or remote support such as telephone and email.

- Independent Intellectual Property Rights

  The technology is independent and compliant with ISO, helping enterprises conduct international business without copyright risks.

## 1.2 PDFSolid Conversion SDK for Ruby

The PDFSolid Conversion Ruby SDK wraps the native PDFSolid Conversion C/C++ runtime for Linux x86_64. It uses the Ruby standard library `Fiddle` to call the native C API and includes a small C bridge for native structures.

The Ruby call chain is:

```text
Ruby
  -> Fiddle
  -> Ruby C bridge
  -> PDFSolid Conversion native library
  -> PDFSolid Conversion C++ SDK
```

The current Ruby SDK release package supports Linux x86_64.

## 1.3 License & Trial

The PDFSolid Conversion SDK is a commercial SDK that requires a license to grant developers the right to develop and distribute their applications. In development mode, each license is only valid for one device ID. PDFSolid provides flexible licensing models. Please contact [our marketing team](mailto:support@pdfsolid.com) for more information. Even if you have a license, it is prohibited to distribute any documents, sample code, or source code of the PDFSolid Conversion SDK to any third parties.

If you do not have a license, please contact the PDFSolid Team at sales@pdfsolid.com to obtain a trial license for PDFSolid Conversion SDK.

# 2. Get Started

## 2.1 Requirements

Before starting, please make sure that you have met the following prerequisites.

### 2.1.1 Get PDFSolid License Key

PDFSolid provides two types of license key: 30-day free trial license and commercial license.

#### How to Get Free Trial License

Contact our sales team at sales@pdfsolid.com and we will send you a 30-day free trial license for PDFSolid Conversion SDK.

#### How to Get Commercial License

PDFSolid Conversion SDK is a commercial SDK that requires a license for application release. Any documents, sample code, or source code distribution from the released package of PDFSolid to any third party is prohibited.

To get a commercial license for PDFSolid Conversion SDK, feel free to contact our sales team at sales@pdfsolid.com.

For the Ruby Conversion SDK, the commercial license must be bound to your developer device ID (How to find the developer device ID), and each license is only valid for one device ID in development mode.

### 2.1.2 Download Conversion SDK

Contact us at sales@pdfsolid.com to obtain the PDFSolid Ruby Conversion SDK.

### 2.1.3 System Requirements

| Development Platform | System Requirements | Development Environment | Notice |
| -------------------- | ------------------- | ----------------------- | ------ |
| Linux | Linux x86_64 | Ruby 2.7 or higher | Samples have been tested on Ubuntu 20.04. |

The Ruby SDK does not require third-party Ruby gems at runtime. It uses Ruby standard libraries, including `Fiddle`, `FileUtils`, `OptionParser`, and `Thread` in samples.

## 2.2 SDK Package Structure

You can contact us at sales@pdfsolid.com to get the PDF format conversion SDK package. The Linux x86_64 release package follows the same top-level structure as the C++ SDK package. From the package root directory, it contains the following files:

```text
doc/
  README.md
  api_reference_ruby.html
  developer_guide_ruby.md
  html/
lib/
  pdfsolid_conversion.rb
  pdfsolid_conversion/
    callback.rb
    conversion.rb
    enums.rb
    error_code.rb
    library_manager.rb
    native.rb
    options.rb
    version.rb
  libpdfsolidconversionsdk.so
  libDocumentAI.so.4.0.0
  libonnxruntime.so.1.18.0
  libopencv_world.so.410
  libpdfsolidconversion_ruby_bridge.so
resource/
  models/
    documentai.model
samples/
  demo/
    demo.rb
  input_files/
    word.pdf
    excel.pdf
    powerpoint.pdf
  output_files/
  license.xml
legal.txt
release_notes.txt
```

The main directories are:

- `doc/`: API reference and developer guide.
- `lib/`: Ruby source files loaded by `require "pdfsolid_conversion"`, the native PDFSolid Conversion runtime libraries, and the Ruby bridge library.
- `resource/`: DocumentAI model resources.
- `samples/`: Ruby demo script, sample input files, license file, and output directory.
- `legal.txt`: Legal and copyright information.
- `release_notes.txt`: Release information.

## 2.3 Apply the License Key

If you do not have a license key, please check out [how to obtain a license key](#211-get-pdfsolid-license-key).

PDFSolid Conversion SDK currently supports offline authentication to verify license keys.

*Learn about:*

*What is the authentication mechanism of PDFSolid's license?*

### 2.3.1 Copy the License Key

Accurately obtaining the license key is crucial for applying the license.

1. In the email you received, locate the XML file containing the license key.
2. Open the XML file and determine the license type based on the `<type>` field. If `<type>online</type>` is present, it indicates an online license. If `<type>offline</type>` is present or if the field is absent, it indicates an offline license.

**Online License:**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<license version="1">
    <platform>windows</platform>
    <starttime>xxxxxxxx</starttime>
    <endtime>xxxxxxxx</endtime>
    <type>online</type>
    <key>LICENSE_KEY</key>
</license>
```

**Offline License:**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<license version="1">
    <platform>windows</platform>
    <starttime>xxxxxxxx</starttime>
    <endtime>xxxxxxxx</endtime>
    <key>LICENSE_KEY</key>
</license>
```

3. Copy the value located at the `LICENSE_KEY` position within the `<key>LICENSE_KEY</key>` field. This is your license key.

### 2.3.2 Apply the License Key

You can perform offline authentication using the following method:

```ruby
require "pdfsolid_conversion"

license = "LICENSE_KEY"
device_id = "DEVICE_ID"
app_id = "com.example.application"

code = PdfSolidConversion::LibraryManager.license_verify(license, device_id, app_id)
unless code == PdfSolidConversion::ErrorCode::SUCCESS
  raise "license verification failed: #{code}"
end
```

Before calling any conversion API, initialize the SDK resource directory:

```ruby
PdfSolidConversion::LibraryManager.initialize_sdk
```

You can also read the license information from environment variables in command-line tools:

```ruby
license = ENV.fetch("PDFSOLID_LICENSE")
device_id = ENV.fetch("PDFSOLID_DEVICE_ID", "")
app_id = ENV.fetch("PDFSOLID_APP_ID", "com.example.application")
```

The sample scripts also accept `--license`, `--device-id`, and `--app-id`. When these options are not provided, they read the same environment variables and fall back to the local demo values packaged in the samples.

## 2.4 How to Run a Demo

### **2.4.1 Linux**

The Ruby SDK release package provides `samples/demo/demo.rb`. Run the commands from the package root directory that contains `doc/`, `lib/`, `resource/`, and `samples/`. When no input PDFs are specified, the demo converts the packaged sample PDFs in `samples/input_files` and writes output files to `samples/output_files`.

```shell
cd /path/to/linux-x86_64
ruby samples/demo/demo.rb
```

You can also pass custom inputs and output directory:

```shell
ruby samples/demo/demo.rb \
  --output /tmp/pdfsolid_ruby_demo_out \
  /path/to/input.pdf
```

You can pass license information through command-line options:

```shell
ruby samples/demo/demo.rb \
  --license /path/to/license.xml \
  --device-id DEVICE_ID \
  --app-id com.example.application \
  --output /tmp/pdfsolid_word_out \
  /path/to/input.pdf
```

Or through environment variables:

```shell
export PDFSOLID_LICENSE="/path/to/license.xml"
export PDFSOLID_DEVICE_ID="DEVICE_ID"
export PDFSOLID_APP_ID="com.example.application"
ruby samples/demo/demo.rb --output /tmp/pdfsolid_word_out /path/to/input.pdf
```

The demo defaults to the package resources when arguments are not provided:

- License: `samples/license.xml`, or `PDFSOLID_LICENSE` / `PDFSOLID_LICENSE_KEY`.
- DocumentAI model: `resource/models/documentai.model`, or `PDFSOLID_MODEL_PATH`.
- Input PDFs: `samples/input_files/word.pdf`, `samples/input_files/excel.pdf`, and `samples/input_files/powerpoint.pdf`.
- Output directory: `samples/output_files`.

The `demo.rb` sample also demonstrates multi-process PDF to Word conversion when explicit input PDFs are provided.

```shell
ruby samples/demo/demo.rb \
  --license /path/to/license.xml \
  --output /tmp/pdfsolid_ruby_demo_out \
  --threads 2 \
  samples/input_files/word.pdf \
  samples/input_files/excel.pdf
```

To load a different DocumentAI model in the demo, pass `--model`:

```shell
ruby samples/demo/demo.rb \
  --output /tmp/pdfsolid_ruby_demo_out \
  --model /path/to/documentai.model \
  /path/to/input.pdf
```

# 3. Conversion Guides

PDFSolid Conversion SDK allows developers to use simple Ruby APIs to convert PDFs to common formats such as Word, Excel, PowerPoint, HTML, CSV, PNG, JPEG, RTF, TXT, Searchable PDF, OFD, JSON, and Markdown. It also provides conversion options, such as whether to include images or annotations, whether to enable OCR, and whether to enable layout analysis.

All Ruby conversion APIs follow the same basic signature:

```ruby
result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  password,
  output_file_path,
  options,
  callback: callback
)
```

`password` can be an empty string when the input PDF is not encrypted. Each conversion method returns an `ErrorCode` value. `ErrorCode::SUCCESS` means the conversion succeeded.

## 3.1 Initialize Library Resources

### Overview

Initialize the necessary file and memory resources required by the PDFSolid Conversion SDK.

The Ruby SDK initializes with its packaged internal resource directory. You do not need to pass a resource path.

### Notes

- You must verify the license and initialize SDK resources before calling any conversion interface.
- When using OCR, Layout Analysis, Table Recognition, PDF to Searchable PDF, or PDF to OFD, make sure the DocumentAI model is available and loaded when the feature requires it.

### Example

```ruby
PdfSolidConversion::LibraryManager.initialize_sdk
```

## 3.2 Set DocumentAI Model

### Overview

Before using OCR, Layout Analysis, Table Recognition, PDF to Searchable PDF, or PDF to OFD, set the DocumentAI model path first.

`set_document_ai_model` supports an optional `gpu_id` parameter used to specify the GPU device index for the AI model. When `gpu_id` is `-1`, GPU acceleration is disabled.

### Set AI Model Instance Count

If you need to control the number of Layout Analysis and Table Recognition model instances, call `set_document_ai_model_count`.

### Sample

```ruby
model_path = "/path/to/documentai.model"
PdfSolidConversion::LibraryManager.set_document_ai_model_count(1, 1)
code = PdfSolidConversion::LibraryManager.set_document_ai_model(model_path, -1)
raise "set_document_ai_model failed: #{code}" unless code == PdfSolidConversion::ErrorCode::SUCCESS
```

### Use Your Own AI Engine (SDK v1.1.0+)

This option is available only in SDK v1.1.0 or later. If you prefer to run OCR, Layout Analysis, or Table Recognition with your own model or a third-party service instead of the bundled DocumentAI model, the C++ SDK exposes callback hooks that let you supply the results as JSON. See [3.11 Use Custom AI Models via Callbacks](#311-use-custom-ai-models-via-callbacks) for details. When all capabilities you need are covered by your own callbacks, `set_document_ai_model` does not have to be called.

## 3.3 Get Conversion Progress

PDFSolid Conversion SDK obtains conversion progress through the `progress` callback. The following example demonstrates how to get conversion progress while performing a PDF to Word task:

```ruby
callback = PdfSolidConversion::ConvertCallback.new(
  progress: ->(current_page, total_page) {
    puts "progress: #{current_page}/#{total_page}"
  }
)
```

Pass the callback through the `callback:` keyword argument:

```ruby
result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  PdfSolidConversion::ConvertOptions.new,
  callback: callback
)
```

## 3.4 Cancel Conversion Task

PDFSolid Conversion SDK supports interrupting an ongoing conversion task through the `cancel` callback. When the `cancel` callback returns `true`, the current conversion task stops as soon as possible.

```ruby
cancel_requested = false

callback = PdfSolidConversion::ConvertCallback.new(
  cancel: -> { cancel_requested }
)
```

If you need to cancel the conversion at a specific time, return `true` from the cancel lambda based on external state.

## 3.5 Select Page Range for Conversion

PDFSolid Conversion SDK supports converting a specified page range. When an empty string is passed, all pages will be converted. If the page range exceeds one page, you can enable `output_document_per_page` to output each PDF page as a separate file.

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.page_ranges = "1-3,5,7-9"
options.output_document_per_page = true
```

## 3.6 Contain Image and Annotation Options

### Overview

When converting PDF documents into various formats, PDFSolid Conversion SDK offers two common options: whether images are included in the generated document, and whether annotations from the PDF file are retained.

- When `contain_image` is enabled, the SDK extracts images from the PDF document and embeds them in the corresponding pages and positions in the output file. For areas with overlapping images, the SDK merges these images into one image and embeds it at the correct location.
- When `contain_annotation` is enabled, most annotations are converted into raster images and embedded at the corresponding positions. Certain types of annotations, such as highlights, underlines, strikeouts, and squiggly lines, are converted into native formatting equivalents in Word, PowerPoint, and HTML documents when possible.

These options are commonly used in the following conversions:

- PDF to Word
- PDF to Excel
- PDF to PowerPoint
- PDF to HTML
- PDF to RTF
- Extract PDF to JSON
- Extract PDF to Markdown

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.contain_image = true
options.contain_annotation = true

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.7 Page Layout Mode

In certain formats, the page layout mode plays a key role in the quality of the converted document. PDFSolid Conversion SDK supports two layout modes: Flow Layout and Box Layout.

- **Flow Layout:** This layout uses paragraph indentations, columns, and tab positions to adjust content. Its main advantage is flexibility. Content can flow automatically as the document is edited and can adapt to different screen sizes.
- **Box Layout:** This layout is based on the PDF fixed-page model and accurately positions text, images, and tables on the page using coordinates. It is useful for documents that require high-precision reproduction, such as contracts, design drafts, and academic papers.

Page layout modes are commonly used in the following conversions:

- PDF to Word
- PDF to HTML

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.page_layout_mode = PdfSolidConversion::PageLayoutMode::FLOW

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)

options.page_layout_mode = PdfSolidConversion::PageLayoutMode::BOX

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.8 OCR

### Overview

OCR (Optical Character Recognition) converts images of typed, handwritten, or printed text into machine-encoded text.

OCR is commonly used for text recognition and extraction from the following types of documents:

- Non-editable scanned PDF files.
- Photographs of documents.
- Scene photos such as advertising layouts and signboards.
- Identification cards, passports, vehicle license plates, invoices, bills, and receipts.

The following features support OCR:

- PDF to Word
- PDF to Excel
- PDF to PowerPoint
- PDF to HTML
- PDF to RTF
- PDF to TXT
- PDF to CSV
- PDF to Searchable PDF
- PDF to OFD
- Extract PDF to JSON
- Extract PDF to Markdown

### OCR Language

Use `languages` to specify OCR languages. The value is an array of `OCRLanguage` constants.

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [
  PdfSolidConversion::OCRLanguage::ENGLISH,
  PdfSolidConversion::OCRLanguage::CHINESE
]
```

Supported OCR language constants include:

| Constant | Description |
| -------- | ----------- |
| `OCRLanguage::CHINESE` | Chinese Simplified |
| `OCRLanguage::CHINESE_TRA` | Chinese Traditional |
| `OCRLanguage::ENGLISH` | English |
| `OCRLanguage::KOREAN` | Korean |
| `OCRLanguage::JAPANESE` | Japanese |
| `OCRLanguage::LATIN` | Latin script languages |
| `OCRLanguage::DEVANAGARI` | Devanagari |
| `OCRLanguage::CYRILLIC` | Cyrillic |
| `OCRLanguage::ARABIC` | Arabic |
| `OCRLanguage::TAMIL` | Tamil |
| `OCRLanguage::TELUGU` | Telugu |
| `OCRLanguage::KANNADA` | Kannada |
| `OCRLanguage::THAI` | Thai |
| `OCRLanguage::GREEK` | Greek |
| `OCRLanguage::ESLAV` | Eslav |
| `OCRLanguage::AUTO` | Automatically select language |

### OCR Options

Different OCR options can be selected according to actual needs:

- `OCROption::INVALID_CHARACTER`: Recognizes invalid or garbled characters in the PDF document through OCR, while normal characters are not processed by OCR.
- `OCROption::SCAN_PAGE`: Recognizes scanned pages in the PDF document through OCR, while editable pages are not processed by OCR.
- `OCROption::INVALID_CHARACTER_AND_SCAN_PAGE`: Recognizes both invalid characters and scanned pages in the PDF document through OCR.
- `OCROption::ALL`: Recognizes all pages and characters in the PDF document through OCR.

```ruby
options.ocr_option = PdfSolidConversion::OCROption::ALL
```

### Preserve Page Background

When OCR is enabled, you can enable `contain_page_background_image` to preserve the original page background image of the PDF. If it is disabled, the image result detected during page layout analysis will be retained.

```ruby
options.contain_page_background_image = true
```

### Notice

- The quality of the OCR result depends on the quality of the input image. A good rule of thumb is that the more pixels in the character shapes, the better. The ideal image is a grayscale image with a resolution around 300 DPI.
- When performing OCR, make sure the OCR language setting matches the language in the PDF document to achieve the best OCR conversion quality.
- OCR functionality currently does not support operating systems lower than Windows 10.

### Converting Images to Other Document Formats

The OCR function also supports converting input images into Word, Excel, PowerPoint, HTML, CSV, RTF, TXT, JSON, and other formats.

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  "input.png",
  "",
  output_file_path,
  options
)
```

## 3.9 Layout Analysis

### Overview

Layout analysis uses AI technology to parse and understand the structure of a document layout. It extracts text, images, tables, layers, and other data from input documents.

Features that support Layout Analysis:

- PDF to Word
- PDF to Excel
- PDF to PowerPoint
- PDF to HTML
- PDF to RTF
- PDF to TXT
- PDF to CSV
- Extract PDF to JSON
- Extract PDF to Markdown

### Notice

- You need to load the DocumentAI model before using layout analysis, or plug in your own AI engine via callbacks described in [3.11 Use Custom AI Models via Callbacks](#311-use-custom-ai-models-via-callbacks).
- When OCR is enabled, layout analysis is automatically enabled.
- AI table recognition is a separate stage controlled by `enable_ai_table_recognition`.

### Sample

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ai_layout = true

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.10 Table Recognition

### Overview

Table Recognition reconstructs the internal structure of tables detected during layout analysis, including rows, columns, merged cells, and cell boundaries, so that the converted document preserves the original tabular semantics instead of producing a flat grid of text fragments.

It is controlled by the independent option `enable_ai_table_recognition`, which is enabled by default. The table model is invoked for table regions detected by layout analysis.

Typical scenarios that benefit from Table Recognition:

- Borderless or partially bordered tables.
- Tables with merged header cells, multi-row headers, or spanning cells.
- Scanned tables processed by OCR.

### Notice

- Table Recognition runs only when layout analysis is active, either through `enable_ai_layout = true` or implicitly through `enable_ocr = true`.
- You need to load the DocumentAI model before using Table Recognition, or plug in your own table model via callbacks described in [3.11 Use Custom AI Models via Callbacks](#311-use-custom-ai-models-via-callbacks).
- Set `enable_ai_table_recognition = false` to disable the table model.
- The number of Table Recognition model instances can be tuned through the second parameter of `set_document_ai_model_count`.

### Sample

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ai_layout = true
options.enable_ai_table_recognition = true

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.11 Use Custom AI Models via Callbacks

### Overview

Starting with SDK v1.1.0, PDFSolid Conversion SDK exposes a callback-based extension point that lets you plug in your own AI inference engine for OCR, Layout Analysis, and Table Recognition. Instead of relying on the built-in DocumentAI model loaded by `set_document_ai_model`, you can run inference with any model or service and return the result to the SDK as a JSON string.

The current Ruby SDK does not expose these callback registration APIs directly. Ruby applications can use the built-in DocumentAI model through `set_document_ai_model`. If a custom AI engine is required, integrate it at the native C/C++ SDK layer and expose a Ruby wrapper only after the native callback lifecycle is fully controlled.

### Notice

- Do not call undocumented native callback functions directly through `Fiddle`.
- Keep model ownership and callback lifetime in native code when adding a Ruby wrapper for custom AI callbacks.

## 3.12 Output Font Option

### Overview

In some output formats, you can set the preferred font name to unify the default font style in the output document.

### Supported Formats

The `font_name` option currently applies to the following formats:

- PDF to Word
- PDF to Excel
- PDF to PowerPoint
- PDF to Searchable PDF
- PDF to OFD

For Searchable PDF and OFD, `font_name` controls the font used for the invisible or visible text layer that is overlaid on the page background. For Word, Excel, and PowerPoint, it sets the preferred default font of the generated document.

### Example

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.font_name = "Arial"

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.13 Convert PDF to Word

### Overview

Converting PDF to Word converts a PDF file into an editable Word file. You can edit, modify, insert, or delete text and pictures, and adjust layout and properties.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.page_layout_mode = PdfSolidConversion::PageLayoutMode::BOX

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)

options.page_layout_mode = PdfSolidConversion::PageLayoutMode::FLOW

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

### Convert Formulas to Images

When a document contains complex formulas and you want to preserve visual consistency in the output document, enable `formula_to_image`.

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.formula_to_image = true

result = PdfSolidConversion::Conversion.start_pdf_to_word(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.14 Convert PDF to Excel

### Overview

PDFSolid Conversion SDK supports converting PDF documents to Microsoft Excel format (.xlsx). By extracting, parsing, and importing data from PDF into Excel, users can further edit, analyze, or share Excel files.

### Excel Options

When converting PDF files to Excel files, pay attention to the following options:

- `excel_all_content`: If enabled, the converted XLSX file contains all content in the PDF.
- `excel_worksheet_option`: Controls how worksheets are created.

| Option | Description |
| ------ | ----------- |
| `ExcelWorksheetOption::FOR_TABLE` | Create one sheet for one table. |
| `ExcelWorksheetOption::FOR_PAGE` | Create one sheet for one PDF page. |
| `ExcelWorksheetOption::FOR_DOCUMENT` | Create one sheet for the entire PDF document. |

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.excel_worksheet_option = PdfSolidConversion::ExcelWorksheetOption::FOR_TABLE

result = PdfSolidConversion::Conversion.start_pdf_to_excel(
  input_file_path,
  "",
  output_file_path,
  options
)

options.excel_all_content = true
options.excel_worksheet_option = PdfSolidConversion::ExcelWorksheetOption::FOR_DOCUMENT

result = PdfSolidConversion::Conversion.start_pdf_to_excel(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.15 Convert PDF to PowerPoint

### Overview

PDFSolid Conversion SDK converts PDF files to PowerPoint files and restores the layout and format of the original document for presentation and editing in Microsoft PowerPoint.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
result = PdfSolidConversion::Conversion.start_pdf_to_ppt(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.16 Convert PDF to HTML

### Overview

PDFSolid Conversion SDK converts PDF files to HTML files while maintaining the layout and format of the original document, allowing users to browse and view the document on the web.

### HTML Options

| Option | Description |
| ------ | ----------- |
| `HtmlOption::SINGLE_PAGE` | Convert the entire PDF file into a single HTML file. |
| `HtmlOption::SINGLE_PAGE_WITH_BOOKMARK` | Convert the PDF file into a single HTML file with an outline for navigation at the beginning of the HTML page. |
| `HtmlOption::MULTI_PAGE` | Convert the PDF file into multiple HTML files. |
| `HtmlOption::MULTI_PAGE_WITH_BOOKMARK` | Convert the PDF file into multiple HTML files with an outline HTML file for navigation. |

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.html_option = PdfSolidConversion::HtmlOption::SINGLE_PAGE

result = PdfSolidConversion::Conversion.start_pdf_to_html(
  input_file_path,
  "",
  output_file_path,
  options
)

options.page_layout_mode = PdfSolidConversion::PageLayoutMode::BOX
options.html_option = PdfSolidConversion::HtmlOption::MULTI_PAGE_WITH_BOOKMARK

result = PdfSolidConversion::Conversion.start_pdf_to_html(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.17 Convert PDF to CSV

### Overview

PDFSolid Conversion SDK supports converting PDF documents to CSV (Comma-Separated Values). This is commonly used to extract tabular or structured data from PDF documents.

CSV conversion uses the Excel conversion API with `excel_csv_format = true`.

### Automatically Create Folders

When multiple CSV files may be output, control whether to automatically create folders through `auto_create_folder`. When this option is enabled, a folder with the same name as the output file will be created in the output path to store the CSV files.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.excel_csv_format = true
options.auto_create_folder = true

result = PdfSolidConversion::Conversion.start_pdf_to_excel(
  input_file_path,
  "",
  output_file_path,
  options
)

options.excel_worksheet_option = PdfSolidConversion::ExcelWorksheetOption::FOR_DOCUMENT

result = PdfSolidConversion::Conversion.start_pdf_to_excel(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.18 Convert PDF to Image

### Overview

PDFSolid Conversion SDK provides an API for converting PDF to images.

### Setting Image Formats

Supported image formats include:

- JPG
- JPEG
- JPEG2000
- PNG
- BMP
- TIFF
- TGA
- GIF
- WEBP

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.image_type = PdfSolidConversion::ImageType::PNG
```

### Setting Image Color Modes

Supported image color modes include:

- `ImageColorMode::COLOR`: Color mode, where the image effect is consistent with the original PDF page.
- `ImageColorMode::GRAY`: Grayscale mode.
- `ImageColorMode::BINARY`: Black and white mode.

```ruby
options.image_color_mode = PdfSolidConversion::ImageColorMode::COLOR
```

### Setting Image Scaling

The SDK supports setting image scaling. If you want to double the image size, set `image_scaling` to `2.0`; to reduce the image size by half, set `image_scaling` to `0.5`.

```ruby
options.image_scaling = 2.0
```

### Enhancing Image Path Display

The SDK supports `image_path_enhance` for enhancing the display of image paths. This option can be enabled when you want to improve the display effect of paths within the PDF page.

- Disable `image_path_enhance` option:
  ![Disable image_path_enhance](/image/1.png)
- Enable `image_path_enhance` option:
  ![Enable image_path_enhance](/image/2.png)

```ruby
options.image_path_enhance = true
```

### Notice

- A higher `image_scaling` value results in images with higher resolution, but it also increases memory usage and slows down conversion.
- A higher `image_scaling` value does not necessarily mean higher clarity. The clarity also depends on the original image resolution in the document.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.image_type = PdfSolidConversion::ImageType::JPEG

result = PdfSolidConversion::Conversion.start_pdf_to_image(
  input_file_path,
  "",
  output_file_path,
  options
)

options.image_type = PdfSolidConversion::ImageType::PNG
options.image_scaling = 2.0

result = PdfSolidConversion::Conversion.start_pdf_to_image(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.19 Convert PDF to RTF

### Overview

RTF is a popular text format that can retain text format and style data and is convenient for most text readers to read and write.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
result = PdfSolidConversion::Conversion.start_pdf_to_rtf(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.20 Convert PDF to TXT

### Overview

When you need to extract text content from a PDF file for data analysis, text mining, or information retrieval, PDFSolid Conversion SDK can extract the text into a TXT file.

### Preserving Table Format

The SDK supports `txt_table_format` to preserve the table format when writing the TXT file. It is generally recommended to enable this option, especially for data extraction scenarios.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.txt_table_format = true

result = PdfSolidConversion::Conversion.start_pdf_to_txt(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.21 Convert PDF to Searchable PDF

### Overview

Searchable PDF conversion adds an invisible or visible text layer to an image-based PDF, such as a scanned document, using OCR.

### Set Transparent Text Layer

When outputting a searchable PDF, use `transparent_text` to control whether the text layer is transparent.

### Sample

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
options.transparent_text = true

result = PdfSolidConversion::Conversion.start_pdf_to_searchable_pdf(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.22 Convert PDF to OFD

### Overview

PDFSolid Conversion SDK supports converting PDF documents to OFD documents. Similar to Searchable PDF, OFD conversion also supports OCR, page background preservation, and transparent text layers.

### Notice

- If you need to generate searchable OFD output, enable `transparent_text`.
- When `enable_ocr` is enabled, specify the OCR language through `languages`.

### Sample

```ruby
PdfSolidConversion::LibraryManager.set_document_ai_model("/path/to/documentai.model", -1)

options = PdfSolidConversion::ConvertOptions.new
options.enable_ocr = true
options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
options.contain_page_background_image = true
options.transparent_text = true

result = PdfSolidConversion::Conversion.start_pdf_to_ofd(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 3.23 Releasing Library Resources

### Overview

Release the file and memory resources occupied by the PDFSolid Conversion SDK.

### Notice

- After calling `release`, the PDFSolid Conversion SDK will no longer function properly and must be initialized again before reuse.
- If you only want to release resources occupied by the AI model rather than all SDK resources, call `release_document_ai_model`.

### Sample

```ruby
PdfSolidConversion::LibraryManager.release_document_ai_model
PdfSolidConversion::LibraryManager.release
```

# 4. Data Extraction Guide

Unleash the power of data with PDFSolid Conversion SDK data extraction to detect, recognize, analyze, and extract PDF text, images, tables, and other content.

## 4.1 Extract PDF to JSON

### Overview

Extract text, tables, and images from PDF documents to a JSON file.

### Standard Table and Non-standard Table

Tables can commonly be divided into two categories:

- Standard table: The table border and inner lines are complete and clear. There is no need to manually add table lines to divide table content.
  ![Standard table example](/image/3.png)
- Non-standard table: The table lacks borders or clear inner lines, requiring manual additions of table lines to separate content.
  ![Non-standard table example](/image/4.png)

### Table Extraction Option

PDFSolid Conversion SDK supports `json_contain_table`. When enabled, the SDK extracts table content from PDFs and outputs the table structure. Otherwise, table content is treated as regular text.

### Notice

- Without enabling AI layout analysis or OCR options, tables in the original PDF may not be extracted. It is recommended to enable AI layout analysis or OCR for high-precision table recognition.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.json_contain_table = true
options.enable_ai_layout = true
options.enable_ai_table_recognition = true

result = PdfSolidConversion::Conversion.start_pdf_to_json(
  input_file_path,
  "",
  output_file_path,
  options
)
```

## 4.2 Extract PDF to Markdown

### Overview

Extract text, tables, and images from PDF documents to a Markdown file.

### Sample

```ruby
options = PdfSolidConversion::ConvertOptions.new
options.enable_ai_layout = true
options.contain_image = true

result = PdfSolidConversion::Conversion.start_pdf_to_markdown(
  input_file_path,
  "",
  output_file_path,
  options
)
```

# 5. Support

## 5.1 FAQ

- Does OCR work on x86 architecture?

  Currently, OCR only works on x64 architecture.

- Why does my Ruby sample fail to load the native library?

  Make sure the `.so` files in the `lib/` directory are accessible and that your system has the required dependencies (`libonnxruntime`, `libopencv_world`).

- Why are my conversion options different from the defaults?

  `ConvertOptions` initializes with default values. Override only the options you need.

## 5.2 Contact Us

Thanks for your interest in PDFSolid Conversion SDK, the easy-to-use and powerful development solution. If you encounter technical questions or bug issues when using PDFSolid Conversion SDK, please submit the problem report to the [PDFSolid team](mailto:support@pdfsolid.com). The following information will help us solve your problem:

- PDFSolid Conversion SDK product and version.
- Your operating system and IDE version.
- Detailed descriptions of the problem.
- Any other related information, such as an error screenshot.

### Contact Information

- Home link: [https://www.pdfsolid.com](https://www.pdfsolid.com/)
- Email: [support@pdfsolid.com](mailto:support@pdfsolid.com)

Thanks,

The PDFSolid Team
