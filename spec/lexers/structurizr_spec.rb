# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Structurizr do
  let(:subject) { Rouge::Lexers::Structurizr.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.structurizr'
      assert_guess :filename => 'foo.dsl'
    end
  end
end
