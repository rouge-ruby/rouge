describe Rouge::Lexers::APIBlueprint do
  let(:subject) { Rouge::Lexers::APIBlueprint.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.apib'
    end

    it 'guesses by source' do
      assert_guess :source => 'FORMAT: 1A\n\n# My API\n'
    end
  end
end
