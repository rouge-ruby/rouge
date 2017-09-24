describe Rouge::Lexers::Thrift do
  let(:subject) { Rouge::Lexers::Thrift.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.thrift'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-thrift'
      assert_guess :mimetype => 'application/x-thrift'
    end
  end
end

