# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexer do
  include Support::Lexing

  it 'guesses the lexer with Lexer.guess' do
    assert { Rouge::Lexer.guess(filename: 'foo.rb').tag == 'ruby' }
  end

  it 'guesses lexers with Lexer.guesses' do
    assert { Rouge::Lexer.guesses(filename: 'foo.pl').map { |c| c.tag }.sort == ['perl', 'prolog'].sort }
  end

  it 'raises errors in .guess by default' do
    assert { (Rouge::Lexer.guess(filename: 'foo.pl') rescue nil) == nil }
  end

  it 'customizes ambiguous cases in .guess' do
    assert { Rouge::Lexer.guess(filename: 'foo.pl') { :fallback } == :fallback }
  end

  it 'makes a simple lexer' do
    a_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule %r/a/, 'A'
        rule %r/b/, 'B'
      end
    end

    # consolidation
    result = a_lexer.lex('aa').to_a
    assert { result.size == 1 }
    assert { result == [['A', 'aa']] }

    result = a_lexer.lex('abab').to_a
    assert { result.size == 4 }
    assert { result == [['A', 'a'], ['B', 'b']] * 2 }
  end

  it 'pushes and pops states' do
    a_lexer = Class.new(Rouge::RegexLexer) do
      state :brace do
        rule %r/b/, 'B'
        rule %r/}/, 'Brace', :pop!
      end

      state :root do
        rule %r/{/, 'Brace', :brace
        rule %r/a/, 'A'
      end
    end

    result = a_lexer.lex('a{b}a').to_a
    assert { result.size == 5 }

    # failed parses

    t = Rouge::Token
    assert {
      a_lexer.lex('{a}').to_a ==
        [['Brace', '{'], [t['Error'], 'a'], ['Brace', '}']]
    }

    assert { a_lexer.lex('b').to_a == [[t['Error'], 'b']] }
    assert { a_lexer.lex('}').to_a == [[t['Error'], '}']] }
  end

  it 'does callbacks and grouping' do
    callback_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule %r/(a)(b)/ do |s|
          groups('A', 'B')
        end
      end
    end

    result = callback_lexer.lex('ab').to_a

    assert { result.size == 2 }
    assert { result[0] == ['A', 'a'] }
    assert { result[1] == ['B', 'b'] }
  end

  it 'pops from the callback' do
    callback_lexer = Class.new(Rouge::RegexLexer) do
      state :root do
        rule %r/a/, 'A', :a
        rule %r/d/, 'D'
      end

      state :a do
        rule %r/b/, 'B', :b
      end

      state :b do
        rule %r/c/ do |ss|
          token 'C'
          pop!; pop! # go back to the root
        end
      end
    end

    assert_no_errors 'abcd', callback_lexer
  end

  it 'supports stateful lexes' do
    stateful = Class.new(Rouge::RegexLexer) do
      def incr
        @count += 1
      end

      state :root do
        rule %r/\d+/ do |ss|
          token 'digit'
          @count = ss[0].to_i
        end

        rule %r/\+/ do |ss|
          incr
          token(@count <= 5 ? 'lt' : 'gt')
        end
      end
    end

    result = stateful.lex('4++')
    types = result.map { |(t,_)| t }
    assert { types == %w(digit lt gt) }
  end

  it 'delegates' do
    class MasterLexer < Rouge::RegexLexer
      state :root do
        rule %r/a/, 'A'
        rule %r/{(.*?)}/ do |m|
          token 'brace', '{'
          delegate BracesLexer.new, m[1]
          token 'brace', '}'
        end
      end
    end

    class BracesLexer < Rouge::RegexLexer
      state :root do
        rule %r/b/, 'B'
      end
    end

    assert_no_errors 'a{b}a', MasterLexer
  end

  it 'detects the beginnings of lines with ^ rules' do
    class MyLexer < Rouge::RegexLexer
      state :root do
        rule %r/^a/, 'start'
        rule %r/a/, 'not-start'
      end
    end

    assert_has_token('start', 'a', MyLexer)
    assert_has_token('start', "\na", MyLexer)
    deny_has_token('not-start', 'a', MyLexer)
    assert_has_token('not-start', 'aa', MyLexer)
  end

  it 'is undetectable by default' do
    UndetectableLexer = Class.new(Rouge::Lexer)

    refute { UndetectableLexer.methods(false).include?(:detect?) }
    refute { UndetectableLexer.detectable? }
  end

  it 'can only be detectable within current scope' do
    class DetectableLexer < Rouge::Lexer
      def self.detect?
        text.shebang?('foobar')
      end
    end

    assert { DetectableLexer.methods(false).include?(:detect?) }
    assert { DetectableLexer.detectable? }

    NonDetectableLexer = Class.new(DetectableLexer)

    refute { NonDetectableLexer.methods(false).include?(:detect?) }
    refute { NonDetectableLexer.detectable? }
  end

  it 'handles boolean options' do
    option_lexer = Class.new(Rouge::RegexLexer) do
      option :bool_opt, 'An example boolean option'

      def initialize(*)
        super
        @bool_opt = bool_option(:bool_opt) { nil }
      end
    end

    assert_equal true, option_lexer.new({bool_opt: 'true'}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: nil}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: false}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: 0}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: '0'}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: 'false'}).instance_variable_get(:@bool_opt)
    assert_equal false, option_lexer.new({bool_opt: 'off'}).instance_variable_get(:@bool_opt)
  end
end
