# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Cfscript do
  let(:subject) { Rouge::Lexers::Cfscript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cfc'
    end

  end
end
