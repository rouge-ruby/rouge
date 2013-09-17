describe Rouge::Lexers::Go do
  let(:subject) { Rouge::Lexers::Go.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.go'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-go'
      assert_guess :mimetype => 'application/x-go'
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

