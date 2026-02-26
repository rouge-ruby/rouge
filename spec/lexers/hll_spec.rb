describe Rouge::Lexers::HLL do
    let(:subject) { Rouge::Lexers::HLL.new }

    describe 'guessing' do
        include Support::Guessing

        it "guesses by filename" do
            assert_guess :filename => "foo.hll"
        end
    end
end
