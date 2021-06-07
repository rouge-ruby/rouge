# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Cypher do
  let(:subject) { Rouge::Lexers::Cypher.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.cypher'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-cypher-query'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    describe 'comments' do
      describe 'inline comment' do
        it 'handles inline comment' do
          assert_tokens_includes "RETURN point({longitude: 2.2105491 /* x */, latitude: 48.9250016 /* y */, srid: 4326}) AS home",
                                 ["Comment.Multiline", "/* x */"],
                                 ["Comment.Multiline", "/* y */"]
        end

        it 'handles multiline comment' do
          assert_tokens_includes "RETURN /* drum\nrolls */ 42",
                                 ["Comment.Multiline", "/* drum\nrolls */"],
                                 ["Literal.Number.Integer", "42"]

        end
      end
    end
  end
end
