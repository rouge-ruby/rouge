# frozen_string_literal: true

describe Rouge::Lexers::Q do
  let(:subject) { Rouge::Lexers::Q.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.q'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-q'
      assert_guess :mimetype => 'application/x-q'
    end
  end
end

