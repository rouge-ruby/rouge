# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Mojo do
  let(:subject) { Rouge::Lexers::Mojo.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.mojo'
      assert_guess :filename => 'foo.🔥'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-mojo'
      assert_guess :mimetype => 'application/x-mojo'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env mojo'
      assert_guess :source => '#!/usr/bin/mojo'
    end
  end
end
