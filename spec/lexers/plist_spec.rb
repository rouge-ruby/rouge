# frozen_string_literal: true

describe Rouge::Lexers::Plist do
  let(:subject) { Rouge::Lexers::Plist.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pbxproj'
      assert_guess :filename => 'foo.plist', :source => 'foo'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-plist'
      assert_guess :mimetype => 'application/x-plist'
    end

    it 'does not guess XML-encoded plists' do
      deny_guess :filename => 'foo.plist', :mimetype => 'application/xml'
      deny_guess :filename => 'foo.plist', :source => '<?xml version="1.0" encoding="UTF-8">'
    end
  end
end
