# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Octave do
  let(:subject) { Rouge::Lexers::Octave.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.m', :source => '# comment'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-octave'
      assert_guess :mimetype => 'application/x-octave'
    end
  end
end
