# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CiscoIos do
  let(:subject) { Rouge::Lexers::CiscoIos.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      # Disambiguate with INI
      assert_guess :filename => 'foo.cfg', :source => "version 13.4"
      assert_guess :filename => 'foo.cfg', :source => "interface FastEthernet0.20"
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cisco-conf'
    end
  end
end
