# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Perl6 do
  let(:subject) { Rouge::Lexers::Perl6.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.pl6'
      assert_guess :filename => 'foo.pm6'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-perl6'
      assert_guess :mimetype => 'application/x-perl6'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env perl6'
    end
  end
end
