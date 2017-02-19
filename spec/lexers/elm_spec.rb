describe Rouge::Lexers::Elm do
  let(:subject) { Rouge::Lexers::Elm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.elm'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'numbers' do
      it 'handles 1 + 1' do
        assert_tokens_equal(
          '1 + 1',
          ['Literal.Number', '1'],
          ['Text', ' '],
          ['Operator', '+'],
          ['Text', ' '],
          ['Literal.Number', '1']
        )
      end
    end

    describe 'punctuation' do
      it 'handles 3.14' do
        assert_tokens_equal(
          '3.14',
          ['Literal.Number', '3'],
          ['Punctuation', '.'],
          ['Literal.Number', '14'],
        )
      end
    end

    describe 'comments' do
      it 'handles one single line comment' do
        assert_tokens_equal(
          '-- a single line comment',
          ["Comment.Single", "-- a single line comment"],
        )
      end

      it 'handles 2 single line comments' do
        assert_tokens_equal(
          "-- comment1\n--comment2",
          ['Comment.Single', "-- comment1"],
          ['Text', "\n"],
          ['Comment.Single', "--comment2"],
        )
      end

      it 'handles multiline comments' do
        skip("Broken, need some kind of state")
        mlc = <<EOS
{- a multiline comment
  {- can be nested -}
-}
EOS
        assert_tokens_equal(
          mlc,
          ['Comment.Multiline', "{- a multiline comment\n  {- can be nested -}\n-}"],
          ['Text', "\n"]
        )
      end

    end
  end

end
