describe Rouge::Lexers::Sass do
  let(:subject) { Rouge::Lexers::Sass.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sass'
    end
  end

  describe 'lexing' do
    include Support::Lexing
    it 'lexes colors' do
      assert_tokens_equal(
        '$foo: aliceblue',
        ['Name.Variable', '$foo'],
        ['Punctuation', ':'],
        ['Text', ' '],
        ['Name.Constant', 'aliceblue'],
      )
    end
  end

end
