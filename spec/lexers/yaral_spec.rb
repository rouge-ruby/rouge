# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::YARAL do
  let(:subject) { Rouge::Lexers::YARAL.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.yaral'
      assert_guess :filename => 'bar.yara-l'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-yaral'
    end

    it 'guesses by source' do
      assert_guess :source => 'rule TestRule {'
      assert_guess :source => "events:\n  \$e.metadata.event_type = \"USER_LOGIN\""
    end
  end
end
