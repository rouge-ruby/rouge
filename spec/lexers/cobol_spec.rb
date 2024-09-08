# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::COBOL do
  let(:subject) { Rouge::Lexers::COBOL.new }

  include Support::Lexing

  it 'highlights COBOL keywords correctly' do
    tokens = subject.lex('IDENTIFICATION DIVISION.').to_a
    assert { tokens.size == 4 }
    assert { tokens.first[0] == Token['Keyword.Declaration'] }
    assert { tokens.last[0] == Token['Punctuation'] }
  end

  it 'highlights COBOL sections correctly' do
    tokens = subject.lex('WORKING-STORAGE SECTION.').to_a
    assert { tokens.size == 4 }
    assert { tokens.first[0] == Token['Keyword.Namespace'] }
    assert { tokens.last[0] == Token['Punctuation'] }
  end

  it 'handles comments correctly' do
    tokens = subject.lex('*> This is a comment').to_a
    assert { tokens.size == 1 }
    assert { tokens.first[0] == Token['Comment.Single'] }
  end

  it 'highlights special comments with asterisks in position 7 correctly' do
    tokens = subject.lex('      * This is a special comment').to_a
    assert { tokens.size == 1 }
    assert { tokens.first[0] == Token['Comment.Special'] }

    tokens = subject.lex('Debug * This is a Debug comment').to_a
    assert { tokens.size == 1 }
    assert { tokens.first[0] == Token['Comment.Special'] }
  end

  it 'ensures strings cannot be multi-line and must match opening and closing quotes' do
    tokens = subject.lex('"This is a string"').to_a
    assert { tokens.size == 3 }
    assert { tokens.first[0] == Token['Literal.String.Double'] }

    tokens = subject.lex("'This is a string'").to_a
    assert { tokens.size == 3 }
    assert { tokens.first[0] == Token['Literal.String.Single'] }

    tokens = subject.lex('"This string doesn\'t close').to_a
    assert { tokens.size == 2 } # Should detect an unclosed string and raise an error or issue a second token
  end

  it 'recognizes operators like "+ (2 ** ...)" correctly' do
    tokens = subject.lex('X = 2 + (2 ** 3)').to_a
    assert { tokens.size == 15 }
    assert { tokens[0][0] == Token['Name'] }
    assert { tokens[2][0] == Token['Operator'] }
    assert { tokens[4][0] == Token['Literal.Number'] }
    assert { tokens[6][0] == Token['Operator'] }
    assert { tokens[8][0] == Token['Punctuation'] }
    assert { tokens[9][0] == Token['Literal.Number'] }
    assert { tokens[11][0] == Token['Operator'] }
    assert { tokens[13][0] == Token['Literal.Number'] }
    assert { tokens[14][0] == Token['Punctuation'] }

  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cob'
      assert_guess :filename => 'foo.cbl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-cobol'
    end
  end
end
