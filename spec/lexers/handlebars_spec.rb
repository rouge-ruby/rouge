describe Rouge::Lexers::Handlebars do
  let(:subject) { Rouge::Lexers::Handlebars.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.handlebars'
      assert_guess :filename => 'foo.hbs'
      assert_guess :filename => 'foo.mustache'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-handlebars'
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
