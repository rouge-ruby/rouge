# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::J do
  let(:subject) { Rouge::Lexers::J.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ijs'
      assert_guess :filename => 'foo.ijt'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'primitives' do
      #        noun        => Keyword.Constant
      #        verb        => Name.Function
      # adverb/conjunction => Operator
      #       copula       => Punctuation

      it 'covers all the verbs' do
        %w'
          =           < <. <:     > >. >:
          + +. +:     - -. -:     * *. *:     % %. %:
          ^ ^.        $ $. $:       ~. ~:     | |. |:
          , ,. ,:     ;    ;:     # #. #:     !
               /:          \:     [    [:     ]
          { {. {: {::   }. }:       ". ":     ? ?.
          A. C. e. E. i. i: I. j. L. o. p. p.. p: q:
          r. s: u. u: v. x: Z:
          _9: _8: _7: _6: _5: _4: _3: _2: _1: 0: 1: 2:
          3: 4: 5: 6: 7: 8: 9: _:
        '.each do |verb|
          assert_tokens_equal verb, ['Name.Function', verb]
        end
      end

      it 'covers all the modifiers' do
        %w'
               ^:     ~           . .. .:     : :. ::
            ;.          !. !:     / /.       \\ \.
          }       }:: "           `    `:     @ @. @:
          & &. &: &.:
          d. D. D: f. F. F.. F.: F: F:. F:: H. L: M. S:
          t. t: T.
        '.each do |modifier|
          assert_tokens_equal modifier, ['Operator', modifier]
        end
      end

      it 'recognizes the other primitives' do
        %w'a. a:'.each do |noun|
          assert_tokens_equal noun, ['Keyword.Constant', noun]
        end
        %w'=. =:'.each do |copula|
          assert_tokens_equal copula, ['Punctuation', copula]
        end
      end

      it 'validates the inflection' do
        assert_tokens_equal '[.q::F:.:. .::',
          ['Error', '[.q::F:.:.'], ['Text', ' '],
          ['Error', '.::']
      end
    end

    describe 'words' do
      it 'accepts names/locatives' do
        assert_tokens_equal 'c',
          ['Name', 'c']
        assert_tokens_equal 'foo_bar',
          ['Name', 'foo_bar']
        assert_tokens_equal 'F00barBAZ',
          ['Name', 'F00barBAZ']
        assert_tokens_equal 'foo_loc_',
          ['Name', 'foo_loc_']
        assert_tokens_equal 'foo_1_',
          ['Name', 'foo_1_']
        assert_tokens_equal 'foo__',
          ['Name', 'foo__']
        assert_tokens_equal 'foo_bar__obj',
          ['Name', 'foo_bar__obj']
        assert_tokens_equal 'foo__obj1__obj2',
          ['Name', 'foo__obj1__obj2']
      end

      it 'rejects non-ascii characters' do
        assert_tokens_equal 'á',
          ['Error', 'á']
      end

      it 'recognizes control words' do
        assert_tokens_equal 'if. do. return. end.',
          ['Keyword', 'if.'], ['Text', ' '],
          ['Keyword', 'do.'],
          ['Text', ' '],
          ['Keyword', 'return.'],
          ['Text', ' '],
          ['Keyword', 'end.']
      end

      it 'recognizes control words that include identifiers' do
        assert_tokens_equal 'for_foo.a.do.end.',
          ['Keyword', 'for_'],
          ['Name', 'foo'],
          ['Keyword', '.'],
          ['Keyword.Constant', 'a.'],
          ['Keyword', 'do.end.']
        assert_tokens_equal 'label_0a.',
          ['Keyword', 'label_'],
          ['Name.Label', '0a'],
          ['Keyword', '.']
      end

      it 'validates the inflection' do
        assert_tokens_equal 'foo. bar: do.. goto_.',
          ['Error', 'foo.'], ['Text', ' '],
          ['Error', 'bar:'], ['Text', ' '],
          ['Error', 'do..'], ['Text', ' '],
          ['Error', 'goto_.']
      end
    end

    describe 'numerics' do
      it 'accepts various forms of numeric constants' do
        assert_tokens_equal '1 _2.4e9 _.j__ _.01 16bff.ee 12345x 3r2p_1',
          ['Literal.Number', '1'], ['Text', ' '],
          ['Literal.Number', '_2.4e9'], ['Text', ' '],
          ['Literal.Number', '_.j__'], ['Text', ' '],
          ['Literal.Number', '_.01'], ['Text', ' '],
          ['Literal.Number', '16bff.ee'], ['Text', ' '],
          ['Literal.Number', '12345x'], ['Text', ' '],
          ['Literal.Number', '3r2p_1']
      end

      it 'validates the inflection' do
        assert_tokens_equal '10: 2.:',
          ['Error', '10:'], ['Text', ' '],
          ['Error', '2.:']
      end
    end

    describe 'strings' do
      it 'recognizes single-quoted text' do
        assert_tokens_equal "'foo bar 12345á!#$@?'",
          ['Literal.String.Single', "'foo bar 12345á!#$@?'"]
      end

      it 'recognizes escape sequences' do
        assert_tokens_equal "'foo''bar'''",
          ['Literal.String.Single', "'foo"],
          ['Literal.String.Escape', "''"],
          ['Literal.String.Single', "bar"],
          ['Literal.String.Escape', "''"],
          ['Literal.String.Single', "'"]
      end

      it 'recognizes no inflection' do
        assert_tokens_equal "'foo'.'bar':",
          ['Literal.String.Single', "'foo'"],
          ['Operator', '.'],
          ['Literal.String.Single', "'bar'"],
          ['Operator', ':']
      end
    end

    describe 'comments' do
      it 'recognizes single line comments' do
        assert_tokens_equal 'NB.foo bar á',
          ['Comment.Single', 'NB.foo bar á']
        assert_tokens_equal "123 NB. foo\nbar",
          ['Literal.Number', '123'],
          ['Text', ' '],
          ['Comment.Single', 'NB. foo'],
          ['Text', "\n"],
          ['Name', 'bar']
      end

      it 'recognizes multiline comments' do
        assert_tokens_equal "Note ''\nfoo\nbar\nbaz\n12345á\n)",
          ['Name', 'Note'], ['Text', ' '],
          ['Literal.String.Single', "''"], ['Text', "\n"],
          ['Comment.Multiline', "foo\nbar\nbaz\n12345á\n"],
          ['Punctuation', ')']
        assert_tokens_equal "0 Note ''",
          ['Literal.Number', '0'], ['Text', ' '],
          ['Name', 'Note'], ['Text', ' '],
          ['Literal.String.Single', "''"]
        assert_tokens_equal "Note\n",
          ['Name', 'Note'], ['Text', "\n"]
        assert_tokens_equal 'Note=: [',
          ['Name', 'Note'],
          ['Punctuation', '=:'], ['Text', ' '],
          ['Name.Function', '[']
      end

      it 'rejects inflected NB./Note' do
        assert_tokens_equal 'NB..foo',
          ['Error', 'NB..'],
          ['Name', 'foo']
        assert_tokens_equal 'Note.1',
          ['Error', 'Note.'],
          ['Literal.Number', '1']
      end
    end

    describe 'explicit definitions' do
      it 'recognizes multiline noun' do
        assert_tokens_equal "noun define\nFOO bar\n*!'~\n  á1`_(\n)",
          ['Keyword.Pseudo', 'noun'], ['Text', ' '],
          ['Keyword.Pseudo', 'define'], ['Text', "\n"],
          ['Literal.String.Heredoc', "FOO bar\n*!'~\n  á1`_(\n"],
          ['Punctuation', ')']
      end

      it 'recognizes multiline code' do
        assert_tokens_equal "verb define\n>:y\n:\nx + y\n)",
          ['Keyword.Pseudo', 'verb'], ['Text', ' '],
          ['Keyword.Pseudo', 'define'], ['Text', "\n"],
          ['Name.Function', '>:'],
          ['Name.Builtin.Pseudo', 'y'], ['Text', "\n"],
          ['Punctuation', ':'], ['Text', "\n"],
          ['Name.Builtin.Pseudo', 'x'], ['Text', ' '],
          ['Name.Function', '+'], ['Text', ' '],
          ['Name.Builtin.Pseudo', 'y'], ['Text', "\n"],
          ['Punctuation', ')']
        assert_tokens_equal "1 :0\nm :\n)",
          ['Keyword.Pseudo', '1'], ['Text', ' '],
          ['Keyword.Pseudo', ':0'], ['Text', "\n"],
          ['Name.Builtin.Pseudo', 'm'], ['Text', ' '],
          ['Operator', ':'], ['Text', "\n"],
          ['Punctuation', ')']
      end

      it 'lexes inside explicit definition literals' do
        assert_tokens_equal "conjunction def '1 -@u ''foo''&v NB.bar'",
          ['Keyword.Pseudo', 'conjunction'], ['Text', ' '],
          ['Keyword.Pseudo', 'def'], ['Text', ' '],
          ['Punctuation', "'"],
          ['Literal.Number', '1'], ['Text', ' '],
          ['Name.Function', '-'],
          ['Operator', '@'],
          ['Name.Builtin.Pseudo', 'u'], ['Text', ' '],
          ['Literal.String.Single', "''foo''"],
          ['Operator', '&'],
          ['Name.Builtin.Pseudo', 'v'], ['Text', ' '],
          ['Comment.Single', 'NB.bar'],
          ['Punctuation', "'"]
      end
    end
  end
end
