describe Rouge::Lexer do
  it 'makes a simple lexer' do
    a_lexer = Rouge::RegexLexer.new do
      rule /a/, 'A'
      rule /b/, 'B'
    end

    token_A = Rouge::Token[:A]
    token_B = Rouge::Token[:B]
    result = a_lexer.get_tokens('aa')

    assert { result.size == 2 }
    assert { result == [[token_A, 'a']] * 2 }
  end

  it 'makes sublexers' do
    a_lexer = Rouge::RegexLexer.new do
      lexer :brace do
        rule /b/, 'B'
        rule /}/, 'Brace', :pop!
      end

      rule /{/, 'Brace', :brace
      rule /a/, 'A'
    end

    result = a_lexer.get_tokens('a{b}a')
    assert { result.size == 5 }

    # failed parses
    assert {
      a_lexer.get_tokens('{a}') ==
        [[Rouge::Token['Brace'], '{'], [Rouge::Token['Text'], 'a}']]
    }

    assert { a_lexer.get_tokens('b') == [[Rouge::Token['Text'], 'b']] }
    assert { a_lexer.get_tokens('}') == [[Rouge::Token['Text'], '}']] }
  end

  it 'does callbacks' do
    callback_lexer = Rouge::RegexLexer.new do
      rule /(a)(b)/ do |_, a, b, &out|
        out.call 'A', a
        out.call 'B', b
      end
    end

    result = callback_lexer.get_tokens('ab')

    assert { result.size == 2 }
    assert { result[0] == [Rouge::Token['A'], 'a'] }
    assert { result[1] == [Rouge::Token['B'], 'b'] }
  end
end
