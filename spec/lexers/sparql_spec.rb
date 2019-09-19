# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SPARQL do
  let(:subject) { Rouge::Lexers::SPARQL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.rq'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/sparql-query'
    end
  end
end
