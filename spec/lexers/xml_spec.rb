# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::XML do
  let(:subject) { Rouge::Lexers::XML.new }
  let(:bom) { "\xEF\xBB\xBF" }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.xml'
      assert_guess :filename => 'foo.xsl'
      assert_guess :filename => 'foo.rss'
      assert_guess :filename => 'foo.xslt'
      assert_guess :filename => 'foo.xsd'
      assert_guess :filename => 'foo.wsdl'
      assert_guess :filename => 'foo.svg'
      assert_guess :filename => 'foo.plist', :source => '<?xml version="1.0" encoding="utf-8"?>'
      deny_guess   :filename => 'foo.plist', :source => 'foo'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/xml'
      assert_guess :mimetype => 'application/xml'
      assert_guess :mimetype => 'image/svg+xml'
      assert_guess :mimetype => 'application/rss+xml'
      assert_guess :mimetype => 'application/atom+xml'
    end

    it 'guesses by source' do
      assert_guess :source => '<?xml version="1.0" encoding="utf-8"?>'
      assert_guess :source => %{#{bom}<?xml version="1.0" encoding="utf-8"?>}
      assert_guess :source => '<?xml version="1.0" ?><html destdir="${reportfolderPath}" encoding="utf-8" />'
      assert_guess :source => '<!DOCTYPE xml>'
      deny_guess   :source => '<!DOCTYPE html>'
      assert_guess :source => '<!DOCTYPE unknown>'
    end
  end
end
