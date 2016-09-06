describe Rouge::Lexers::Jsx do
  let(:subject) { Rouge::Lexers::Jsx.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.???'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-jsx'
      assert_guess :mimetype => 'application/x-jsx'
    end

    it 'guesses by source' do
      assert_guess :source => '????'
    end
  end
end

