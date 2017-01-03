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
      assert_tokens_equal 'MOV R7, R16',
                          ['Keyword', 'MOV'],
                          ['Text.Whitespace', ' '],
                          ['Name.Builtin.Pseudo', 'R7'],
                          ['Punctuation', ','],
                          ['Text.Whitespace', ' '],
                          ['Error', 'R16']
    end

    it 'label definition' do
      assert_tokens_equal 'label1: ',
                          ['Name.Label', 'label1:'],
                          ['Text.Whitespace', ' ']
    end

    it 'comments' do
      assert_tokens_equal 'MOV --Hey! ',
                          ['Keyword', 'MOV'],
                          ['Text.Whitespace', ' '],
                          ['Comment.Single', '--Hey! ']
    end

    it 'correct and wrong hexadecimal numbers' do
      assert_tokens_equal 'MOV 0x11FF 0X111G',
                          ['Keyword', 'MOV'],
                          ['Text.Whitespace', ' '],
                          ['Literal.Number.Hex', '0x11FF'],
                          ['Text.Whitespace', ' '],
                          ['Error', '0X111G']
    end
  end
end
