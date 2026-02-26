# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Cake do
  let(:subject) { Rouge::Lexers::Cake.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'build.cake'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cake'
    end
  end
end
