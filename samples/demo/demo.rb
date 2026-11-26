#!/usr/bin/env ruby
# frozen_string_literal: true

# Sample for Conversion SDK for Ruby.
#
# Usage:
#   ruby samples/demo/demo.rb
#   ruby samples/demo/demo.rb --output samples/output_files
#   ruby samples/demo/demo.rb --output /tmp/out /path/to/input.pdf
#   ruby samples/demo/demo.rb --output /tmp/out --threads 2 input1.pdf input2.pdf
#
# Defaults:
#   - License: resource/license/license.xml, or CONVERSION_LICENSE.
#   - Model: resource/models/documentai.model from the current release package.
#   - Runtime: lib/ for Linux, or lib/windows-x86_64 for Windows.
#   - No input PDFs: convert samples/input_files with the C demo style conversion suite.

require "fileutils"
require "json"
require "optparse"
require "rbconfig"
require "thread"

PACKAGE_ROOT = File.expand_path("../..", __dir__)
PACKAGE_LIB = File.join(PACKAGE_ROOT, "lib")
SOURCE_LIB = File.expand_path("../../lib", __dir__)
[PACKAGE_LIB, SOURCE_LIB].each do |load_path|
  $LOAD_PATH.unshift(load_path) if File.directory?(load_path) && !$LOAD_PATH.include?(load_path)
end

require "pdfsolid_conversion"

SUCCESS = PdfSolidConversion::ErrorCode::SUCCESS
SAMPLE_COMMAND = "ruby samples/demo/demo.rb"
DEFAULT_LICENSE_PATH = File.expand_path("../../resource/license/license.xml", __dir__)
DEFAULT_MODEL_PATH = File.join(PACKAGE_ROOT, "resource/models/documentai.model")
SOURCE_MODEL_PATH = PdfSolidConversion::DEFAULT_DOCUMENT_AI_MODEL_PATH
DEFAULT_INPUT_DIR = File.expand_path("../input_files", __dir__)
DEFAULT_OUTPUT_DIR = File.expand_path("../output_files", __dir__)


def license_file_path?(license)
  value = license.to_s
  value.downcase.end_with?(".xml") || File.exist?(File.expand_path(value))
end


def normalize_license_value(license)
  value = license.to_s
  raise ArgumentError, "License is required. Pass --license or set CONVERSION_LICENSE." if value.empty?

  if license_file_path?(value)
    resolved = File.expand_path(value)
    raise ArgumentError, "License file not found: #{resolved}" unless File.file?(resolved)
    return resolved
  end

  value
end


def default_license_options
  {
    license: ENV["CONVERSION_LICENSE"] || DEFAULT_LICENSE_PATH,
    device_id: ENV.fetch("CONVERSION_DEVICE_ID", ""),
    app_id: ENV.fetch("CONVERSION_APP_ID", ""),
    resource: ENV.fetch("CONVERSION_RESOURCE_PATH", "")
  }
end


def default_model_path
  ENV["CONVERSION_MODEL_PATH"] || (File.file?(DEFAULT_MODEL_PATH) ? DEFAULT_MODEL_PATH : SOURCE_MODEL_PATH)
end


def parse_args(argv)
  license_options = default_license_options
  app_id_specified = ENV.key?("CONVERSION_APP_ID")
  options = {
    license_options: license_options,
    model: default_model_path,
    output: DEFAULT_OUTPUT_DIR,
    threads: 5,
    suite: "all",
    inputs: []
  }

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{SAMPLE_COMMAND} [options] [input1.pdf] [input2.pdf ...]"
    opts.separator ""
    opts.separator "Options:"
    opts.on("--license VALUE", "License string or license XML file path. Defaults to CONVERSION_LICENSE or resource/license/license.xml") { |value| license_options[:license] = value }
    opts.on("--device-id ID", "Device ID. Defaults to CONVERSION_DEVICE_ID") { |value| license_options[:device_id] = value }
    opts.on("--app-id ID", "Application ID. Defaults to CONVERSION_APP_ID") do |value|
      license_options[:app_id] = value
      app_id_specified = true
    end
    opts.on("--resource PATH", "SDK resource directory. Defaults to CONVERSION_RESOURCE_PATH") { |value| license_options[:resource] = value }
    opts.on("-o", "--output DIR", "Output directory. Defaults to samples/output_files") { |value| options[:output] = value }
    opts.on("-m", "--model PATH", "DocumentAI model path. Defaults to CONVERSION_MODEL_PATH or the packaged model") { |value| options[:model] = value }
    opts.on("-t", "--threads N", Integer, "Worker process count. Default: 5") { |value| options[:threads] = value }
    opts.on("--suite NAME", %w[all office], "Demo suite: all (default) or office (Word, Excel, PPT)") { |value| options[:suite] = value }
    opts.on("-h", "--help", "Show help") do
      puts opts
      exit
    end
  end

  rest_args = parser.parse(argv)
  options[:inputs] = rest_args
  raise ArgumentError, "office uses the three packaged PDFs" if options[:suite] == "office" && !rest_args.empty?

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


def report_result(step, code)
  path = ENV["CONVERSION_DEMO_REPORT"]
  File.open(path, "a") { |file| file.puts(JSON.generate(step: step, code: code)) } if path && !path.empty?
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
  report_result(label, result)
  raise "#{label} failed with result=#{result}" unless result == SUCCESS
end


def verify_and_initialize(license_options, model_path)
  license_code = PdfSolidConversion::LibraryManager.license_verify(
    license_options[:license],
    license_options[:device_id],
    license_options[:app_id]
  )
  puts "license_verify => #{license_code}"
  report_result("license", license_code)
  exit 1 unless license_code == SUCCESS

  PdfSolidConversion::LibraryManager.initialize_sdk(license_options[:resource])
  PdfSolidConversion::LibraryManager.set_logger(false, true)
  puts "version => #{PdfSolidConversion::LibraryManager.version}"

  return if model_path.to_s.empty?

  model_code = PdfSolidConversion::LibraryManager.set_document_ai_model(model_path, -1)
  puts "set_document_ai_model => #{model_code}"
  report_result("model", model_code)
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

    docx = File.join(DEFAULT_INPUT_DIR, "word.docx")
    ranged = PdfSolidConversion::ConvertOptions.new
    ranged.page_ranges = "1-2"
    ranged.word_pdf_bookmark_mode = PdfSolidConversion::WordPdfBookmarkMode::HEADINGS
    [
      ["word to pdf", "word_to_pdf.pdf", PdfSolidConversion::ConvertOptions.new],
      ["word to pdf with options", "word_to_pdf_bookmarks.pdf", ranged]
    ].each do |label, filename, word_options|
      pdf = File.join(output_dir, filename)
      code = PdfSolidConversion::Conversion.start_word_to_pdf(docx, pdf, word_options)
      report_result(label, code)
      puts "#{label}: #{code}"
      raise "#{label} did not produce a PDF; SDK code #{code}" unless [0, 95].include?(code) && File.size?(pdf)
      warn "PDF produced with unsupported Word features." if code == 95
    end

    if options[:suite] == "office"
      puts "all office conversion tasks finished"
      return
    end

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
    run_conversion("pdf to searchable pdf", :start_pdf_to_searchable_pdf, excel_pdf, File.join(output_dir, "pdf.pdf"), searchable_options)

    ofd_options = box_layout_options
    ofd_options.enable_ocr = true
    ofd_options.transparent_text = true
    ofd_options.languages = [PdfSolidConversion::OCRLanguage::ENGLISH]
    run_conversion("pdf to ofd", :start_pdf_to_ofd, word_pdf, File.join(output_dir, "pdf.ofd"), ofd_options)

    puts "all conversion tasks finished"
  ensure
    PdfSolidConversion::LibraryManager.release_document_ai_model
    PdfSolidConversion::LibraryManager.release
  end
end


def run_worker
  worker_id = ENV.fetch("CONVERSION_RUBY_DEMO_WORKER_ID", "1")
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
        "CONVERSION_RUBY_DEMO_WORKER" => "1",
        "CONVERSION_RUBY_DEMO_WORKER_ID" => worker_id.to_s,
        "CONVERSION_LICENSE" => options[:license_options][:license].to_s,
        "CONVERSION_DEVICE_ID" => options[:license_options][:device_id].to_s,
        "CONVERSION_APP_ID" => options[:license_options][:app_id].to_s,
        "CONVERSION_RESOURCE_PATH" => options[:license_options][:resource].to_s
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

if ENV["CONVERSION_RUBY_DEMO_WORKER"] == "1"
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
