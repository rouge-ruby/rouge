# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Bicep do
  let(:subject) { Rouge::Lexers::Bicep.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.bicep'
      deny_guess :filename => 'foo'
    end
  end
end
