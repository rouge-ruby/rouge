# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Mason do
  let(:subject) { Rouge::Lexers::Mason.new }

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
  
  eos
  
    end
    
    it 'guesses by source when using component calls' do
      assert_guess :filename => 'foo.m', :source => <<-eos
      <& 'SELF:component' &>
  
  eos
  
    end

  end
end
