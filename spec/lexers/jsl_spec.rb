# -*- coding: utf-8 -*- #

describe Rouge::Lexers::JSL do
  let(:subject) { Rouge::Lexers::JSL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jsl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-jsl'
    end
  end
end
