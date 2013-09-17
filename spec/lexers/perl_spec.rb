describe Rouge::Lexers::Perl do
  let(:subject) { Rouge::Lexers::Perl.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      # *.pl needs source hints because it's also used by Prolog
      assert_guess :filename => 'foo.pl', :source => 'my $foo = 1'
      assert_guess :filename => 'foo.pm'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-perl'
      assert_guess :mimetype => 'application/x-perl'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/perl'
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
