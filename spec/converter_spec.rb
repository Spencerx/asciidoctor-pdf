require_relative 'spec_helper'

describe Asciidoctor::Pdf::Converter do
  context '.register_for' do
    it 'should self register to handle pdf backend' do
      (expect Asciidoctor::Converter.for 'pdf').to be Asciidoctor::Pdf::Converter
    end

    it 'should convert AsciiDoc string to PDF object when backend is pdf' do
      (expect Asciidoctor.convert 'hello', backend: 'pdf').to be_a Prawn::Document
    end

    it 'should convert AsciiDoc file to PDF file when backend is pdf' do
      pdf = to_pdf (Pathname fixture_file 'hello.adoc'), to_dir: output_dir
      (expect Pathname output_file 'hello.pdf').to exist
      (expect pdf.page_count).to be > 0
    end
  end

  context '#convert' do
    it 'should not fail to convert empty string' do
      (expect to_pdf '').to_not be_nil
    end

    it 'should not fail to convert empty file' do
      pdf = to_pdf (Pathname fixture_file 'empty.adoc'), to_dir: output_dir
      (expect Pathname output_file 'empty.pdf').to exist
      (expect pdf.page_count).to be > 0
    end

    it 'should ignore data-uri if set' do
      doc = Asciidoctor.load <<~'EOS', backend: 'pdf', base_dir: fixtures_dir, safe: :safe
      :data-uri:

      image::logo.png[]
      EOS
      (expect doc.attr? 'data-uri', '').to be true
      doc.convert
      (expect doc.attr? 'data-uri').to be false
    end
  end
end
