# -*- coding: utf-8 -*- #

describe Rouge::Lexers::LoomScript do
  let(:subject) { Rouge::Lexers::LoomScript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ls'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/loomscript'
      assert_guess :mimetype => 'application/loomscript'
      assert_guess :mimetype => 'text/x-loomscript'
      assert_guess :mimetype => 'application/x-loomscript'
    end
  end
end
