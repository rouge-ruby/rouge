# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::JSON do
  let(:subject) { Rouge::Lexers::JSON.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.json'
      assert_guess :filename => 'Pipfile.lock'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/json'
      assert_guess :mimetype => 'application/vnd.api+json'
      assert_guess :mimetype => 'application/hal+json'
      assert_guess :mimetype => 'application/problem+json'
      assert_guess :mimetype => 'application/schema+json'
    end

    it 'guesses by source' do
      assert_guess :mimetype => 'application/json', :source => '{"name": "value"}'
    end
  end
end
