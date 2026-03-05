# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SPL do
  let(:subject) { Rouge::Lexers::SPL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.spl'
      assert_guess :filename => 'foo.splunk'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-spl'
    end

    it 'guesses by source' do
      assert_guess :source => '| stats count BY host'
      assert_guess :source => '| eval x=if(status>=400, "error", "ok")'
    end
  end
end
