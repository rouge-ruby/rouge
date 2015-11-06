# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Fortran do
  let(:subject) { Rouge::Lexers::Fortran.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.f90'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-fortran'
    end
  end
end
