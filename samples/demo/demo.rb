#!/usr/bin/env ruby
# frozen_string_literal: true

# Sample for PdfSolid Conversion SDK for Ruby.
#
# Usage:
#   ruby samples/demo.rb
#   ruby samples/demo.rb --output samples/output_files
#   ruby samples/demo.rb --output /tmp/out /path/to/input.pdf
#   ruby samples/demo.rb --output /tmp/out --threads 2 input1.pdf input2.pdf
#
# Defaults:
#   - License: samples/license.xml, or PDFSOLID_LICENSE / PDFSOLID_LICENSE_KEY.
#   - Model: resource/models/documentai.model from the current release package.
#   - Runtime: lib/pdfsolid_conversion/vendor for the current platform.
#   - No input PDFs: convert samples/input_files with the C demo style conversion suite.

require "fileutils"
require "optparse"
require "rbconfig"
require "thread"

PACKAGE_LIB = File.expand_path("../../lib", __dir__)
SOURCE_LIB = File.expand_path("../lib", __dir__)
[PACKAGE_LIB, SOURCE_LIB].each do |load_path|
  $LOAD_PATH.unshift(load_path) if File.directory?(load_path) && !$LOAD_PATH.include?(load_path)
end

require "pdfsolid_conversion"

SUCCESS = PdfSolidConversion::ErrorCode::SUCCESS
RELEASE_SAMPLE = File.basename(__dir__) == "demo"
SAMPLE_COMMAND = RELEASE_SAMPLE ? "ruby samples/demo/demo.rb" : "ruby samples/demo.rb"
DEFAULT_LICENSE_PATH = File.expand_path(RELEASE_SAMPLE ? "../license.xml" : "license.xml", __dir__)
DEFAULT_MODEL_PATH = File.expand_path("../../resource/models/documentai.model", __dir__)
SOURCE_MODEL_PATH = PdfSolidConversion::DEFAULT_DOCUMENT_AI_MODEL_PATH
DEFAULT_RELEASE_INPUT_DIR = File.expand_path("../input_files", __dir__)
DEFAULT_SOURCE_INPUT_DIR = File.expand_path("../../../../version/ruby/linux-x86_64/samples/input_files", __dir__)
DEFAULT_INPUT_DIR = RELEASE_SAMPLE ? DEFAULT_RELEASE_INPUT_DIR : DEFAULT_SOURCE_INPUT_DIR
DEFAULT_OUTPUT_DIR = File.expand_path(RELEASE_SAMPLE ? "../output_files" : "output_files", __dir__)


def license_file_path?(license)
  value = license.to_s
  value.downcase.end_with?(".xml") || File.exist?(File.expand_path(value))
end


def normalize_license_value(license)
  value = license.to_s
  raise ArgumentError, "License is required. Pass --license or set PDFSOLID_LICENSE." if value.empty?

  if license_file_path?(value)
    resolved = File.expand_path(value)
    raise ArgumentError, "License file not found: #{resolved}" unless File.file?(resolved)
    return resolved
  end

  value
end


def default_license_options
  {
    license: ENV["PDFSOLID_LICENSE"] || ENV["PDFSOLID_LICENSE_KEY"] || DEFAULT_LICENSE_PATH,
    device_id: ENV.fetch("PDFSOLID_DEVICE_ID", ""),
    app_id: ENV["PDFSOLID_APP_ID"] || ENV["PDFSOLID_LICENSE_PACKAGE"] || "com.pdfsolid.conversion.demo",
    resource: ENV.fetch("PDFSOLID_RESOURCE_PATH", "")
  }
end


def default_model_path
  ENV["PDFSOLID_MODEL_PATH"] || (File.file?(DEFAULT_MODEL_PATH) ? DEFAULT_MODEL_PATH : SOURCE_MODEL_PATH)
end


def parse_args(argv)
  license_options = default_license_options
  app_id_specified = ENV.key?("PDFSOLID_APP_ID") || ENV.key?("PDFSOLID_LICENSE_PACKAGE")
  options = {
    license_options: license_options,
    model: default_model_path,
    output: DEFAULT_OUTPUT_DIR,
    threads: 5,
    inputs: []
  }

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{SAMPLE_COMMAND} [options] [input1.pdf] [input2.pdf ...]"
    opts.separator ""
    opts.separator "Options:"
    opts.on("--license VALUE", "License string or license XML file path. Defaults to PDFSOLID_LICENSE or samples/license.xml") { |value| license_options[:license] = value }
    opts.on("--device-id ID", "Device ID. Defaults to PDFSOLID_DEVICE_ID") { |value| license_options[:device_id] = value }
    opts.on("--app-id ID", "Application ID. Defaults to PDFSOLID_APP_ID") do |value|
      license_options[:app_id] = value
      app_id_specified = true
    end
    opts.on("--resource PATH", "SDK resource directory. Defaults to PDFSOLID_RESOURCE_PATH") { |value| license_options[:resource] = value }
    opts.on("-o", "--output DIR", "Output directory. Defaults to samples/output_files") { |value| options[:output] = value }
    opts.on("-m", "--model PATH", "DocumentAI model path. Defaults to PDFSOLID_MODEL_PATH or the packaged model") { |value| options[:model] = value }
    opts.on("-t", "--threads N", Integer, "Worker process count. Default: 5") { |value| options[:threads] = value }
    opts.on("-h", "--help", "Show help") do
      puts opts
      exit
    end
  end

  rest_args = parser.parse(argv)
  options[:inputs] = rest_args

  if !app_id_specified && license_file_path?(license_options[:license])
    license_options[:app_id] = ""
  end
  license_options[:license] = normalize_license_value(license_options[:license])

  options
rescue OptionParser::ParseError, ArgumentError => e
  warn e.message
  warn parser
  exit 2
end


def ensure_input_pdf(input_path)
  resolved = File.expand_path(input_path)
  raise ArgumentError, "Input PDF not found: #{resolved}" unless File.file?(resolved)
  resolved
end


def ensure_output_dir(output_dir)
  resolved = File.expand_path(output_dir)
  FileUtils.mkdir_p(resolved)
  resolved
end


def ensure_sample_input(file_name)
  ensure_input_pdf(File.join(DEFAULT_INPUT_DIR, file_name))
end


def word_output_path(input_pdf, output_dir)
  File.join(output_dir, "#{File.basename(input_pdf, File.extname(input_pdf))}.docx")
end


def default_options
  options = PdfSolidConversion::ConvertOptions.new
  options.transparent_text = true
  options.image_scaling = 4.0
  options.page_layout_mode = PdfSolidConversion::PageLayoutMode::FLOW
  options.languages = [PdfSolidConversion::OCRLanguage::CHINESE]
  options
end


def box_layout_options
  options = default_options
  options.page_layout_mode = PdfSolidConversion::PageLayoutMode::BOX
  options
end


def conversion_callback(label)
  PdfSolidConversion::ConvertCallback.new(
    progress: ->(current, total) { puts "[#{label}] progress: #{current}/#{total}" },
    cancel: -> { false }
  )
end


def run_conversion(label, method_name, input_pdf, output_path, options)
  result = PdfSolidConversion::Conversion.public_send(
    method_name,
    input_pdf,
    "",
    output_path,
    options,
    callback: conversion_callback(label)
  )
  puts "#{label}: result=#{result}, output=#{output_path}"
  raise "#{label} failed with result=#{result}" unless result == SUCCESS
end


def verify_and_initialize(license_options, model_path)
  license_code = PdfSolidConversion::LibraryManager.license_verify(
    license_options[:license],
    license_options[:device_id],
    license_options[:app_id]
  )
  puts "license_verify => #{license_code}"
  exit 1 unless license_code == SUCCESS

  PdfSolidConversion::LibraryManager.initialize_sdk(license_options[:resource])
  PdfSolidConversion::LibraryManager.set_logger(false, true)
  puts "version => #{PdfSolidConversion::LibraryManager.version}"

  return if model_path.to_s.empty?

  model_code = PdfSolidConversion::LibraryManager.set_document_ai_model(model_path, -1)
  puts "set_document_ai_model => #{model_code}"
  exit 1 unless model_code == SUCCESS
end


def run_conversion_suite(options)
  output_dir = ensure_output_dir(options[:output])
  word_pdf = ensure_sample_input("word.pdf")
  excel_pdf = ensure_sample_input("excel.pdf")
  powerpoint_pdf = ensure_sample_input("powerpoint.pdf")

  begin
    verify_and_initialize(options[:license_options], options[:model])

    run_conversion("pdf to word", :start_pdf_to_word, word_pdf, File.join(output_dir, "word.docx"), default_options)
    run_conversion("pdf to excel", :start_pdf_to_excel, excel_pdf, File.join(output_dir, "excel.xlsx"), default_options)
    run_conversion("pdf to ppt", :start_pdf_to_ppt, powerpoint_pdf, File.join(output_dir, "powerpoint.pptx"), default_options)

    csv_options = default_options
    csv_options.excel_csv_format = true
    run_conversion("pdf to csv", :start_pdf_to_excel, excel_pdf, output_dir, csv_options)

    layout_options = box_layout_options
    run_conversion("pdf to html", :start_pdf_to_html, word_pdf, File.join(output_dir, "html.html"), layout_options)
    run_conversion("pdf to rtf", :start_pdf_to_rtf, word_pdf, File.join(output_dir, "rtf.rtf"), layout_options)
    run_conversion("pdf to image", :start_pdf_to_image, word_pdf, output_dir, layout_options)
    run_conversion("pdf to txt", :start_pdf_to_txt, word_pdf, File.join(output_dir, "txt.txt"), layout_options)
    run_conversion("pdf to json", :start_pdf_to_json, word_pdf, File.join(output_dir, "json.json"), layout_options)
    run_conversion("pdf to markdown", :start_pdf_to_markdown, word_pdf, File.join(output_dir, "markdown.md"), layout_options)

    searchable_options = box_layout_options
    searchable_options.enable_ocr = true
    searchable_options.transparent_text = true
    searchable_options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
    run_conversion("pdf to searchable pdf", :start_pdf_to_searchable_pdf, word_pdf, File.join(output_dir, "pdf.pdf"), searchable_options)

    run_conversion("pdf to ofd", :start_pdf_to_ofd, word_pdf, File.join(output_dir, "pdf.ofd"), layout_options)

    puts "all conversion tasks finished"
  ensure
    PdfSolidConversion::LibraryManager.release_document_ai_model
    PdfSolidConversion::LibraryManager.release
  end
end


def run_worker
  worker_id = ENV.fetch("PDFSOLID_RUBY_DEMO_WORKER_ID", "1")
  input_pdf = ensure_input_pdf(ARGV.fetch(0))
  output_file = ARGV.fetch(1)
  model_path = ARGV.fetch(2, "")
  options = parse_args([])

  begin
    verify_and_initialize(options[:license_options], model_path)
    result = PdfSolidConversion::Conversion.start_pdf_to_word(
      input_pdf,
      "",
      output_file,
      default_options,
      callback: PdfSolidConversion::ConvertCallback.new(
        progress: ->(current, total) { puts "[Worker-#{worker_id}] progress: #{current}/#{total}" },
        cancel: -> { false }
      )
    )
    puts "[Worker-#{worker_id}] finished: result=#{result}, output=#{output_file}"
    exit(result == SUCCESS ? 0 : 1)
  ensure
    PdfSolidConversion::LibraryManager.release_document_ai_model
    PdfSolidConversion::LibraryManager.release
  end
end


def run_explicit_inputs(options)
  input_files = options[:inputs].map { |path| ensure_input_pdf(path) }
  output_dir = ensure_output_dir(options[:output])
  tasks = input_files.each_with_index.map do |input_pdf, index|
    [index + 1, input_pdf, word_output_path(input_pdf, output_dir)]
  end

  worker_count = [[options[:threads].to_i, 1].max, tasks.length].min
  running = {}
  failed = false
  next_worker_id = 1

  until tasks.empty? && running.empty?
    while running.length < worker_count && !tasks.empty?
      _task_id, input_pdf, output_file = tasks.shift
      worker_id = next_worker_id
      next_worker_id += 1
      puts "[Worker-#{worker_id}] start: #{input_pdf}"

      env = {
        "PDFSOLID_RUBY_DEMO_WORKER" => "1",
        "PDFSOLID_RUBY_DEMO_WORKER_ID" => worker_id.to_s,
        "PDFSOLID_LICENSE" => options[:license_options][:license].to_s,
        "PDFSOLID_DEVICE_ID" => options[:license_options][:device_id].to_s,
        "PDFSOLID_APP_ID" => options[:license_options][:app_id].to_s,
        "PDFSOLID_RESOURCE_PATH" => options[:license_options][:resource].to_s
      }
      pid = Process.spawn(env, RbConfig.ruby, __FILE__, input_pdf, output_file, options[:model].to_s, out: $stdout, err: $stderr)
      running[pid] = true
    end

    pid, status = Process.wait2
    running.delete(pid)
    failed = true unless status.success?
  end

  puts "all conversion tasks finished"
  exit(1) if failed
end

if ENV["PDFSOLID_RUBY_DEMO_WORKER"] == "1"
  run_worker
else
  unless RUBY_PLATFORM =~ /linux|mswin|mingw|cygwin/i
    warn "This sample supports Linux x86_64 and Windows x86_64. Current Ruby platform is #{RUBY_PLATFORM}."
    exit 2
  end

  options = parse_args(ARGV)
  if options[:inputs].empty?
    run_conversion_suite(options)
  else
    run_explicit_inputs(options)
  end
end
