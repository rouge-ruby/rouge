describe Rouge::Lexers::INI do
  let(:subject) { Rouge::Lexers::INI.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ini'
      assert_guess :filename => '.gitconfig'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-ini'
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
