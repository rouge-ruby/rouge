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

  it 'does callbacks and grouping' do
    callback_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule /(a)(b)/ do |s|
          group 'A'
          group 'B'
        end
      end
    end

    result = callback_lexer.lex('ab').to_a

    assert { result.size == 2 }
    assert { result[0] == [Rouge::Token['A'], 'a'] }
    assert { result[1] == [Rouge::Token['B'], 'b'] }
  end

  it 'pops from the callback' do
    callback_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule /a/, 'A', :a
        rule /d/, 'D'
      end

      state :a do
        rule /b/, 'B', :b
      end

      state :b do
        rule /c/ do |ss|
          token 'C'
          pop!; pop! # go back to the root
        end
      end
    end

    result = callback_lexer.lex('abcd')
    errors = result.select { |(t,_)| t.name == 'Error' }
    assert { errors.empty? }
  end

  it 'supports stateful lexes' do
    stateful = Class.new(Rouge::RegexLexer) do
      state :root do
        rule /\d+/ do |ss|
          token 'digit'
          @count = ss[0].to_i
        end

        rule /\+/ do |ss|
          @count += 1
          token(@count <= 5 ? 'lt' : 'gt')
        end
      end
    end

    result = stateful.lex('4++')
    types = result.map { |(t,_)| t.name }
    assert { types == %w(digit lt gt) }
  end
end
