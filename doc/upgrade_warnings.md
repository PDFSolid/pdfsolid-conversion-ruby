# PDFSolid Conversion SDK for Ruby 1.3.0 Upgrade Warnings

Update the Ruby SDK and the bundled `documentai.model` together when upgrading
from 1.2.0. The default table recognition profile changed from high accuracy
to balanced.

`ConvertOptions#table_recognition_accuracy` defaults to
`TableRecognitionAccuracy::BALANCED` (`1`).
`TableRecognitionAccuracy::HIGH_ACCURACY` (`0`) requires the
`table_legacy.model` extension package to be loaded with
`LibraryManager.set_document_ai_model`. If it is not loaded, the conversion
still succeeds, but tables are recognized with the rule-based method instead, so
the result differs from the high-accuracy result.

`LibraryManager.license_type` returns `LicenseType::UNKNOWN`, `TRIAL`, or
`FORMAL` (`0`, `1`, `2`) for the license already verified by the process. It
does not verify again or consume page quota.

The 1.3.0 SDK also documents `ConvertOptions#word_pdf_bookmark_mode` and
`WordPdfBookmarkMode` for `Conversion.start_word_to_pdf`.

## Migration from earlier 1.3 development builds

`DocumentAITableModelProfile` was renamed to `TableRecognitionAccuracy`; the numeric values remain `HIGH_ACCURACY = 0` and `BALANCED = 1`.

The global `LibraryManager.set_document_ai_model_profile` API was removed. Set `table_recognition_accuracy` on each conversion options object instead. `LibraryManager` also no longer defines `TABLE_MODEL_HIGH_ACCURACY` or `TABLE_MODEL_BALANCED`; use `TableRecognitionAccuracy` constants. Loading a model does not select the profile for a task.

The `table_model_profile` field from earlier 1.3 development builds was renamed to `table_recognition_accuracy`. The old field name is no longer supported.

`WordToPdfOptions` was removed. Word to PDF now uses the shared `ConvertOptions`; replace `bookmark_mode` with `word_pdf_bookmark_mode`. Only `page_ranges` and `word_pdf_bookmark_mode` take effect; all other options are ignored. Defaults output every page with no bookmarks. Word to PDF was introduced in 1.3.0.

## Model loading and runtime libraries

Upgrade the language wrapper, native library, and addon/bridge/shim together. Deploy the 1.3.0 `documentai.model`; the old file lacks balanced-profile resources. `LibraryManager.set_document_ai_model` merges packages incrementally and preserves already loaded capabilities if another package fails. Configure or reload models only when all conversion calls have returned; changes during conversion or release return code `60`.

## Image input

Image-to-image conversion does not run OCR or layout analysis; multi-page TIFF input is processed frame by frame, with page ranges selecting frames. With OCR disabled, image-to-TXT and image-to-CSV return `95` (`UNSUPPORTED_FEATURE`); enable `enable_ocr` for these outputs. Other image-capable output formats retain the complete source image without recognized text when OCR is disabled.

`enable_auto_page_size` (default `false`) selects the nearest standard page size from image resolution. `custom_page_width` and `custom_page_height` (default `0`) set dimensions in points (1/72 inch). Setting both takes precedence over automatic sizing and fits the image proportionally without cropping. These options apply only to image input.

Word to PDF may return `95` for unsupported features while still producing output. Check the output file; the Ruby wrapper does not expose the C/C++ diagnostics buffer.

## Linux Delivery ZIP

The delivery is `PDFSolid_Conversion_linux_ruby_1_3_0.zip`. Replace the binding, native libraries and model together, preserving the relative `doc/include/lib/resource/samples` layout. No npm, gem or Composer installation is required in this delivery.

The Linux core uses system fonts. Initialization and model loading are separate steps; do not pass the model directory as the initialization resource path. The bundled license has an expiration date. Validate the Word, Excel and PPT examples with:

```bash
ruby samples/demo/demo.rb --suite office
```

## Custom AI callbacks

The binding supports `on_ocr/on_ocr_result`、`on_layout/on_layout_result`、`on_table/on_table_result` callback pairs. Triggers receive an image path and synchronously return a boolean; getters return JSON following the C/C++ schema. Callback exceptions are rethrown after native conversion returns.
