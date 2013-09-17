describe Rouge::Lexers::Puppet do
  let(:subject) { Rouge::Lexers::Puppet.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pp'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/puppet apply'
      assert_guess :source => '#!/usr/bin/puppet-apply'
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
