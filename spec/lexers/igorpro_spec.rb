# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::IgorPro do
  let(:subject) { Rouge::Lexers::IgorPro.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ipf'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-igorpro'
    end
  end
end
