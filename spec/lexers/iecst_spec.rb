# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::IecST do
  let(:subject) { Rouge::Lexers::IecST.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.awl'
      assert_guess :filename => 'foo.scl'
      assert_guess :filename => 'foo.st', :source => "VAR;\n END_VAR;\n"
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-iecst'
    end
  end
end
