describe Rouge::Lexers::VCL do
  let(:subject) { Rouge::Lexers::VCL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'config.vcl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-vcl'
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
