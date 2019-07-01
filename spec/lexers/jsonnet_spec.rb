# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Jsonnet do
  let(:subject) { Rouge::Lexers::Jsonnet.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jsonnet'
      assert_guess :filename => 'foo.libsonnet'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-jsonnet'
    end
  end
end
