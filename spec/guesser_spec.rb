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
  end
end
