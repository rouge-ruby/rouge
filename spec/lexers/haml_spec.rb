describe Rouge::Lexers::Haml do
  let(:subject) { Rouge::Lexers::Haml.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.html.haml'
      assert_guess :filename => 'foo.haml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-haml'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes custom filters' do
      lexer = Rouge::Lexers::Haml.new(:filters => { :tex => 'tex' })

      assert_has_token 'Comment', <<-tex, lexer
        :tex
          % this is a tex comment!
      tex
    end

    it 'lexes the demo with no errors' do
      assert_no_errors(lexing_demo)
    end

    it 'lexes the sample without throwing' do
      lex_sample.to_a
    end
  end
end
