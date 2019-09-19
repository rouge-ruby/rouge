# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Gradle do
  let(:subject) { Rouge::Lexers::Gradle.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'build.gradle'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gradle'
    end
  end
end
