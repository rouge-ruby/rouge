# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Meson do
  let(:subject) { Rouge::Lexers::Meson.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'meson.build'
      assert_guess :filename => 'meson_options.txt'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-meson'
    end
  end
end
