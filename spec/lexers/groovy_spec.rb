# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Groovy do
  let(:subject) { Rouge::Lexers::Groovy.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.groovy'
      assert_guess :filename => 'Jenkinsfile'
      assert_guess :filename => 'foo.Jenkinsfile'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-groovy'
    end
  end
end
