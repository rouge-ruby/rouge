# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GHCCmm do
  let(:subject) { Rouge::Lexers::GHCCmm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'Main.dump-cmm'
      assert_guess :filename => 'Main.dump-cmm-switch'
      assert_guess :filename => 'Main.dump-cmm-sp'
      assert_guess :filename => 'Main.dump-cmm-sink'
      assert_guess :filename => 'Main.dump-cmm-raw'
      assert_guess :filename => 'Main.dump-cmm-info'
      assert_guess :filename => 'Main.dump-cmm-from-stg'
      assert_guess :filename => 'Main.dump-cmm-cps'
      assert_guess :filename => 'Main.dump-cmm-cfg'
      assert_guess :filename => 'Main.dump-cmm-cbe'
      assert_guess :filename => 'Main.dump-cmm-caf'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'should lex section markers as headings' do
      core = '==================== Output Cmm ===================='
      assert_tokens_equal core, ['Generic.Heading', core]
    end

    it 'should lex timestamps as comments' do
      core = '2019-12-24 13:23:29.666399 UTC'
      assert_tokens_equal core, ['Comment.Single', core]
    end

    it 'should lex brackets as punctuation' do
      core = '[]'
      assert_tokens_equal core, ['Punctuation', '[]']
    end
  end
end


