# -*- coding: utf-8 -*- #

describe Rouge::Lexers::D do
  let(:subject) { Rouge::Lexers::D.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.d'
      assert_guess :filename => 'foo.di'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dsrc'
      assert_guess :mimetype => 'application/x-dsrc'
    end
  end
end
