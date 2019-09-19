# frozen_string_literal: true

describe Rouge::Guesser do
  include Support::Guessing

  describe 'guessing with custom globs' do
    it 'guesses correctly' do
      assert_guess(Rouge::Lexers::Javascript,
        :custom_globs => [['*.pl', 'javascript']],
        :filename => 'oddly-named.pl'
      )
    end
  end

  describe 'guessing with custom guessing strategies' do
    it 'guesses in order' do
      assert_guess(Rouge::Lexers::Ruby,
        :guessers => [
          Rouge::Guessers::Source.new('#!/usr/bin/env ruby'),
          Rouge::Guessers::Filename.new('foo.md'),
        ]
      )

      assert_guess(Rouge::Lexers::Markdown,
        :guessers => [
          Rouge::Guessers::Filename.new('foo.md'),
          Rouge::Guessers::Source.new('#!/usr/bin/env ruby'),
        ]
      )
    end

    it 'uses custom guessers' do
      passed_lexers = nil

      custom = Class.new(Rouge::Guesser) {
        define_method(:filter) { |lexers|
          passed_lexers = lexers

          [Rouge::Lexers::Javascript]
        }
      }.new

      assert_guess(Rouge::Lexers::Javascript, :guessers => [custom])
      assert { passed_lexers.size == Rouge::Lexer.all.size }
    end

    it 'sequentially filters' do
      custom = Class.new(Rouge::Guesser) {
        define_method(:filter) { |lexers|
          passed_lexers = lexers

          [Rouge::Lexers::Javascript, Rouge::Lexers::Prolog]
        }
      }.new

      assert_guess(Rouge::Lexers::Prolog,
        :guessers => [
          custom,
          Rouge::Guessers::Filename.new('foo.pl'),
        ]
      )
    end

    it 'filters with a lambda' do
      assert_guess(Rouge::Lexers::C,
        :guessers => [
          ->(lexers) { [ Rouge::Lexers::C ] }
        ]
      )
    end
  end

  describe 'modeline guessing' do
    it 'guesses by modeline' do
      # don't confuse actual editors when opening this file lol
      assert_guess(Rouge::Lexers::Ruby, :source => '# v' + 'im: syntax=ruby')
    end
  end
end
