describe Rouge::Lexers::Matlab do
  let(:subject) { Rouge::Lexers::Matlab.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.m'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-matlab'
      assert_guess :mimetype => 'application/x-matlab'
    end

    it 'guesses by source' do
      assert_guess :source => <<-source
  % Comments start with a percent sign.
  sin(x)
      source
    end
  end
end

