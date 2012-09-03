describe Rouge::Lexer do
  it 'makes a simple lexer' do
    a_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule /a/, 'A'
        rule /b/, 'B'
      end
    end

    token_A = Rouge::Token[:A]
    token_B = Rouge::Token[:B]
    result = a_lexer.lex('aa').to_a

    assert { result.size == 2 }
    assert { result == [[token_A, 'a']] * 2 }
  end

  it 'makes sublexers' do
    a_lexer = Class.new(Rouge::RegexLexer) do
      state :brace do
        rule /b/, 'B'
        rule /}/, 'Brace', :pop!
      end

      state :root do
        rule /{/, 'Brace', :brace
        rule /a/, 'A'
      end
    end

    result = a_lexer.lex('a{b}a').to_a
    assert { result.size == 5 }

    # failed parses

    t = Rouge::Token
    assert {
      a_lexer.lex('{a}').to_a ==
        [[t['Brace'], '{'], [t['Error'], 'a'], [t['Brace'], '}']]
    }

    assert { a_lexer.lex('b').to_a == [[Rouge::Token['Error'], 'b']] }
    assert { a_lexer.lex('}').to_a == [[Rouge::Token['Error'], '}']] }
  end

  it 'does callbacks' do
    callback_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule /(a)(b)/ do |s, &out|
          out.call 'A', s[1]
          out.call 'B', s[2]
        end
      end
    end

    result = callback_lexer.lex('ab').to_a

    assert { result.size == 2 }
    assert { result[0] == [Rouge::Token['A'], 'a'] }
    assert { result[1] == [Rouge::Token['B'], 'b'] }
  end
end
