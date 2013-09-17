describe Rouge::Lexers::YAML do
  let(:subject) { Rouge::Lexers::YAML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.yml'
      assert_guess :filename => 'foo.yaml'
      assert_guess :filename => '.travis.yml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-yaml'
    end

    it 'guesses by source' do
      assert_guess :source => "\n\n%YAML 1.2"
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes the demo with no errors' do
      assert_no_errors(lexing_demo)
    end

    it 'lexes the sample without throwing' do
      lex_sample.to_a
    end
  end
end
