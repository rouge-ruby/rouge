describe Rouge::Lexers::Prolog do
  let(:subject) { Rouge::Lexers::Prolog.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pro'
      assert_guess :filename => 'foo.P'
      assert_guess :filename => 'foo.prolog'
      assert_guess :filename => 'foo.pl'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-prolog'
    end

    it 'guesses by source' do
      assert_guess :source => <<-PROLOG
mother_child(trude, sally).

father_child(tom, sally).
father_child(tom, erica).
father_child(mike, tom).

sibling(X, Y)      :- parent_child(Z, X), parent_child(Z, Y).
      PROLOG
    end
  end
end
