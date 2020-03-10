# frozen_string_literal: true

describe Rouge::Lexers::Tap do
  let(:subject) { Rouge::Lexers::Tap.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tap'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-tap'
      assert_guess :mimetype => 'application/x-tap'
    end
  end
end

