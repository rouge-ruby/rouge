# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Powershell do
  let(:subject) { Rouge::Lexers::Powershell.new }
  
  # Someone may need to add actual tests here. TODO

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ps1'
      assert_guess :filename => 'foo.psm1'
    end

  end
end
