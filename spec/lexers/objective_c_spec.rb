describe Rouge::Lexers::Objective_c do
  let(:subject) { Rouge::Lexers::Objective_c.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.???'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-objective_c'
      assert_guess :mimetype => 'application/x-objective_c'
    end

    it 'guesses by source' do
      assert_guess :source => '????'
    end
  end
end

