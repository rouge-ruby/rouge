# -*- coding: utf-8 -*- #

describe Rouge::Lexers::SML do
  let(:subject) { Rouge::Lexers::SML.new }

  describe 'lexing' do
    include Support::Lexing

    it 'handles let..in..end' do
      assert_tokens_equal "let\n  val x = 3;\nin\n  3 + 3\nend;",
        ["Keyword.Reserved", "let"],
        ["Text", "\n  "],
        ["Keyword.Reserved", "val"],
        ["Text", " "],
        ["Name.Variable", "x"],
        ["Text", " "],
        ["Punctuation", "="],
        ["Text", " "],
        ["Literal.Number.Integer", "3"],
        ["Punctuation", ";"],
        ["Text", "\n"],
        ["Keyword.Reserved", "in"],
        ["Text", "\n  "],
        ["Literal.Number.Integer", "3"],
        ["Text", " "],
        ["Punctuation", "+"],
        ["Text", " "],
        ["Literal.Number.Integer", "3"],
        ["Text", "\n"],
        ["Keyword.Reserved", "end"],
        ["Punctuation", ";"]
    end

    it 'handles local..in..end' do
      assert_tokens_equal "local\n  val x = 3;\nin\n  val y = x + x\nend;",
        ["Keyword.Reserved", "local"],
        ["Text", "\n  "],
        ["Keyword.Reserved", "val"],
        ["Text", " "],
        ["Name.Variable", "x"],
        ["Text", " "],
        ["Punctuation", "="],
        ["Text", " "],
        ["Literal.Number.Integer", "3"],
        ["Punctuation", ";"],
        ["Text", "\n"],
        ["Keyword.Reserved", "in"],
        ["Text", "\n  "],
        ["Keyword.Reserved", "val"],
        ["Text", " "],
        ["Name.Variable", "y"],
        ["Text", " "],
        ["Punctuation", "="],
        ["Text", " "],
        ["Name", "x"],
        ["Text", " "],
        ["Punctuation", "+"],
        ["Text", " "],
        ["Name", "x"],
        ["Text", "\n"],
        ["Keyword.Reserved", "end"],
        ["Punctuation", ";"]
    end

    it "handles pattern matching" do
      assert_tokens_equal "val square =\n  fn 1 => 1\n | _ => _ * _;",
        ["Keyword.Reserved", "val"],
        ["Text", " "],
        ["Name.Variable", "square"],
        ["Text", " "],
        ["Punctuation", "="],
        ["Text", "\n  "],
        ["Keyword.Reserved", "fn"],
        ["Text", " "],
        ["Literal.Number.Integer", "1"],
        ["Text", " "],
        ["Punctuation", "=>"],
        ["Text", " "],
        ["Literal.Number.Integer", "1"],
        ["Text", "\n "],
        ["Punctuation", "|"],
        ["Text", " "],
        ["Name", "_"],
        ["Text", " "],
        ["Punctuation", "=>"],
        ["Text", " "],
        ["Name", "_"],
        ["Text", " "],
        ["Punctuation", "*"],
        ["Text", " "],
        ["Name", "_"],
        ["Punctuation", ";"]
    end
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      # Not testing '*.ml', since it's more commonly
      # used for OCaml source files.
      assert_guess :filename => 'foo.sml'
      assert_guess :filename => 'foo.sig'
      assert_guess :filename => 'foo.fun'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-standardml'
      assert_guess :mimetype => 'application/x-standardml'
    end
  end
end

