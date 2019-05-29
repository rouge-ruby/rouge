# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Mason do
  let(:subject) { Rouge::Lexers::Mason.new }
  let(:bom) { "\xEF\xBB\xBF" }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.mas'
      assert_guess :filename => 'foo.mi'
      assert_guess :filename => 'foo.mc'
      assert_guess :filename => 'foo.mhtml'
      assert_guess :filename => 'foo.mcomp'
      assert_guess :filename => 'autohandler'
      assert_guess :filename => 'dhandler'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-mason'
      assert_guess :mimetype => 'application/x-mason'
    end

    it 'guesses by source' do
      assert_guess :filename => 'foo.m', :source => <<-eos
      <%doc>
      This is a mason component.
  </%doc>
  
  <%args>
      $color         # this argument is required!
      $size => 20    # default size
      $country => undef   # this argument is optional, default value is 'undef'
      @items => (1, 2, 'something else')
      %pairs => (name => "John", age => 29)
  </%args>
  
  # A random block of Perl code
  <%perl>
      my @people = ('mary' 'john' 'pete' 'david');
  </%perl>
  
  # Note how each line of code begins with the mandatory %
  % foreach my $person (@people) {
      Name: <% $person %>
  % }
  eos
  
    end

  end
end
