# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Red do
  let(:subject) { Rouge::Lexers::Red.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess filename: 'foo.red'
    end

    it 'guesses by mimetype' do
      assert_guess mimetype: 'text/red'
    end
  end
end
