describe Rouge::Lexers::Conf do
  let(:subject) { Rouge::Lexers::Conf.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess   :filename => 'foo.conf'

      # this should be lexed with the special nginx lexer
      # instead.
      deny_guess :filename => 'nginx.conf'
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
