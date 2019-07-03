# frozen_string_literal: true

describe Rouge::Lexers::Tulip do
  let(:subject) { Rouge::Lexers::Tulip.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tlp'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-tulip'
      assert_guess :mimetype => 'application/x-tulip'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env tulip'
    end
  end
end

