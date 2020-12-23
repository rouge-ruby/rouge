# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::RML do
  let(:subject) { Rouge::Lexers::RML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rml'
    end
  end
end
