# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::PHP do
  let(:subject) { Rouge::Lexers::PHP.new }

  describe 'guessing' do
    include Support::Guessing

    it 'Guesses files containing <?php' do
      assert_guess :source => '<?php foo();'
    end

    it 'Guesses PHP files that do not contain Hack code' do
      assert_guess :filename => 'foo.php', :source => '<? foo();'
    end

    it 'Guesses .php files containing <?, but not hack code' do
      deny_guess :filename => 'foo.php', :source => '<?hh // strict'
    end

    it "Does not guess files containing <?hh" do
      deny_guess :source => '<?hh foo();'
      deny_guess :source => '<?hh // strict'
      deny_guess :filename => '.php', :source => '<?hh foo();'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'recognizes hash comments not followed by a newline (#797)' do
      assert_tokens_equal '# comment', ['Comment.Single', '# comment']
    end

    it 'recognizes double-slash comments not followed by a newline (#797)' do
      assert_tokens_equal '// comment', ['Comment.Single', '// comment']
    end

    it 'recognizes try catch finally definition' do
      assert_tokens_equal 'try {} catch () {} finally {}', ["Keyword", "try"], ["Text", " "], ["Punctuation", "{}"], ["Text", " "], ["Keyword", "catch"], ["Text", " "], ["Punctuation", "()"], ["Text", " "], ["Punctuation", "{}"], ["Text", " "], ["Keyword", "finally"], ["Text", " "], ["Punctuation", "{}"]
    end

    it 'recognizes class definition' do
      assert_tokens_equal 'class A {}', ["Keyword.Declaration", "class"], ["Text", " "], ["Name.Class", "A"], ["Text", " "], ["Punctuation", "{}"]
    end

    it 'recognizes interface definition' do
      assert_tokens_equal 'interface A {}', ["Keyword.Declaration", "interface"], ["Text", " "], ["Name.Class", "A"], ["Text", " "], ["Punctuation", "{}"]
    end

    it 'recognizes trait definition' do
      assert_tokens_equal 'trait A {}', ["Keyword.Declaration", "trait"], ["Text", " "], ["Name.Class", "A"], ["Text", " "], ["Punctuation", "{}"]
    end

    it 'recognizes case insensitively keywords' do
      assert_tokens_equal 'While', ["Keyword", "While"]; subject.reset_stack
      assert_tokens_equal 'Class BAR', ["Keyword.Declaration", "Class"], ["Text", " "], ["Name.Class", "BAR"]; subject.reset_stack
      assert_tokens_equal 'Const BAR', ["Keyword", "Const"], ["Text", " "], ["Name.Constant", "BAR"]; subject.reset_stack
      assert_tokens_equal 'Use BAR', ["Keyword.Namespace", "Use"], ["Text", " "], ["Name.Constant", "BAR"]; subject.reset_stack
      assert_tokens_equal 'NameSpace BAR', ["Keyword.Namespace", "NameSpace"], ["Text", " "], ["Name.Namespace", "BAR"]; subject.reset_stack
      # function for anonymous functions is also recognized as a regular keyword
      assert_tokens_equal 'Function (', ["Keyword", "Function"], ["Text", " "], ["Punctuation", "("]; subject.reset_stack
      assert_tokens_equal 'Function foo', ["Keyword", "Function"], ["Text", " "], ["Name", "foo"]; subject.reset_stack
    end

    it 'recognizes case sensitively E_* and PHP_* as constants' do
      assert_tokens_equal 'PHP_EOL', ["Keyword.Constant", "PHP_EOL"]; subject.reset_stack
      assert_tokens_equal 'PHP_EOL_1', ["Name.Constant", "PHP_EOL_1"]; subject.reset_stack

      assert_tokens_equal 'E_user_DEPRECATED', ["Name", "E_user_DEPRECATED"]; subject.reset_stack
      assert_tokens_equal 'E_USER_deprecated', ["Name", "E_USER_deprecated"]; subject.reset_stack
      assert_tokens_equal 'E_USER_DEPRECATED', ["Keyword.Constant", "E_USER_DEPRECATED"]; subject.reset_stack
    end
  end
end
