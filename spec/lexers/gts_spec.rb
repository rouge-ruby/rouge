describe Rouge::Lexers::Gts do
  let(:subject) { Rouge::Lexers::Gts.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gts'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gts'
      assert_guess :mimetype => 'application/x-gts'
    end
  end
end