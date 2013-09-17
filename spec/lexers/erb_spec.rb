describe Rouge::Lexers::ERB do
  let(:subject) { Rouge::Lexers::ERB.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.html.erb'
      assert_guess :filename => 'foo.eruby'
      assert_guess :filename => 'foo.rhtml'
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
