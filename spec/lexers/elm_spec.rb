describe Rouge::Lexers::Elm do
  let(:subject) { Rouge::Lexers::Elm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.elm'
    end

  end
end
