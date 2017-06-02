describe Rouge::Lexers::TSX do
  let(:subject) { Rouge::Lexers::TSX.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.tsx'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-tsx'
      assert_guess :mimetype => 'application/x-tsx'
    end
  end
end


