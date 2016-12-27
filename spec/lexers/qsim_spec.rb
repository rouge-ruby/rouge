describe Rouge::Lexers::QSim do
  let(:subject) { Rouge::Lexers::QSim.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.qsim'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'operator call' do
      assert_tokens_equal 'MOV R15, R16',
                          ['Keyword', 'MOV'],
                          ['Text.Whitespace', ' '],
                          ['Name.Attribute', 'R15'],
                          ['Punctuation', ','],
                          ['Text.Whitespace', ' '],
                          ['Error', 'R16']
    end
  end
end
