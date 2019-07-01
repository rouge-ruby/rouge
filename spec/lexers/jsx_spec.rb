# frozen_string_literal: true

describe Rouge::Lexers::JSX do
  let(:subject) { Rouge::Lexers::JSX.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.jsx'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-jsx'
      assert_guess :mimetype => 'application/x-jsx'
    end
  end
end

