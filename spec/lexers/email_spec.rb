# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Email do
  let(:subject) { Rouge::Lexers::Email.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.eml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'message/rfc822'
    end
  end
end
