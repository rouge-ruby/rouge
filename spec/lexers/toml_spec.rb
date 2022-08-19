# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::TOML do
  let(:subject) { Rouge::Lexers::TOML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.toml'
      assert_guess :filename => 'Pipfile'
      assert_guess :filename => 'poetry.lock'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-toml'
    end
  end
end
