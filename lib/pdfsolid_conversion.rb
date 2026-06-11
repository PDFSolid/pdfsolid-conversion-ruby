require_relative "pdfsolid_conversion/version"
require_relative "pdfsolid_conversion/error_code"
require_relative "pdfsolid_conversion/enums"
require_relative "pdfsolid_conversion/options"
require_relative "pdfsolid_conversion/callback"
require_relative "pdfsolid_conversion/native"
require_relative "pdfsolid_conversion/library_manager"
require_relative "pdfsolid_conversion/conversion"

module PdfSolidConversion
  DEFAULT_DOCUMENT_AI_MODEL_PATH = File.expand_path("pdfsolid_conversion/model/documentai.model", __dir__)
end