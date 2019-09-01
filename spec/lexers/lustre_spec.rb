# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Lustre do
  let(:subject) { Rouge::Lexers::Lustre.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.lus'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-lustre'
    end
  end
end
