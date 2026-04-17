# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Rocq do
  let(:subject) { Rouge::Lexers::Rocq.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-coq'
      assert_guess :mimetype => 'text/x-rocq'
    end
  end
end
