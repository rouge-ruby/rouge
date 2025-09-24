describe Rouge::Lexers::Gjs do
  let(:subject) { Rouge::Lexers::Gjs.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gjs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gjs'
      assert_guess :mimetype => 'application/x-gjs'
    end
  end
end