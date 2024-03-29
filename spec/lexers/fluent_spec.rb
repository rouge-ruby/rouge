# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Fluent do
  let(:subject) { Rouge::Lexers::Fluent.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ftl'
    end
  end
end
