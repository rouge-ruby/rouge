describe Rouge::Lexers::ERB do
  let(:subject) { Rouge::Lexers::ERB.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.html.erb'
      assert_guess :filename => 'foo.eruby'
      assert_guess :filename => 'foo.rhtml'
    end

    it 'guesses by source' do
      assert_guess :source => '<% foo %>'
      assert_guess :source => '<%%>'
    end
  end
end
