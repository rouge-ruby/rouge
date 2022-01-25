# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Hcl do
  let(:subject) { Rouge::Lexers::Hcl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.hcl'
      assert_guess :filename => 'foo.nomad'
    end
  end
end
