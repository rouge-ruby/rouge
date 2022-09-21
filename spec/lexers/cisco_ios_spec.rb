# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::CiscoIos do
  let(:subject) { Rouge::Lexers::CiscoIos.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cfg'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cisco-conf'
    end
  end
end
