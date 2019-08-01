# -*- coding: utf-8 -*- #

describe Rouge::Lexers::SAS do
  let(:subject) { Rouge::Lexers::SAS.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sas'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-sas'
      assert_guess :mimetype => 'application/x-stat-sas'
      assert_guess :mimetype => 'application/x-sas-syntax'
    end
  end
end

