describe Rouge::Lexers::Varnish do
  let(:subject) { Rouge::Lexers::Varnish.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'varnish.vcl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-varnish'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'forwards C blocks to C lexer' do
      assert_tokens_equal 'foo C{int}C bar', ['Text', 'foo '], [ 'Comment.Preproc', 'C{' ], [ 'Keyword.Type', 'int' ], [ 'Comment.Preproc', '}C' ], [ 'Text', ' bar' ] 
    end
  end
end
