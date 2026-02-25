# frozen_string_literal: true

describe Rouge::Lexers::Svelte do
  let(:subject) { Rouge::Lexers::Svelte.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.svelte'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-svelte'
      assert_guess :mimetype => 'application/x-svelte'
    end
  end
end
