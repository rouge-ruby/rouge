# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Email do
  let(:subject) { Rouge::Lexers::Email.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.eml'
      assert_guess :filename => 'foo.mail'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'message/rfc822'
    end

    it 'guesses by source' do
      assert_guess :source => 'From: Me <me@example.com>'
    end
  end
end
