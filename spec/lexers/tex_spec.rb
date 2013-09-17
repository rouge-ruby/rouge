describe Rouge::Lexers::TeX do
  let(:subject) { Rouge::Lexers::TeX.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tex'
      assert_guess :filename => 'foo.toc'
      assert_guess :filename => 'foo.aux'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-tex'
      assert_guess :mimetype => 'text/x-latex'
    end

    it 'guesses by source' do
      assert_guess :source => '\\documentclass{article}'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes the demo with no errors' do
      assert_no_errors(lexing_demo)
    end

    it 'lexes the sample without throwing' do
      lex_sample.to_a
    end
  end
end
