describe Rouge::Lexers::Elixir do
  let(:subject) { Rouge::Lexers::Elixir.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ex'
      assert_guess :filename => 'foo.exs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-elixir'
      assert_guess :mimetype => 'application/x-elixir'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes double colon as punctuation' do
      assert_tokens 'Elixir::Builtin',
        ['Name.Constant', 'Elixir'],
        ['Punctuation',   '::'],
        ['Name.Constant', 'Builtin']
    end

    private

    def assert_tokens(text, *expected)
      actual = subject.lex(text).map { |token, value| [ token.name, value ] }
      assert_equal expected, actual
    end
  end
end
