# -*- coding: utf-8 -*- #

describe Rouge::Lexers::SQF do
  let(:subject) { Rouge::Lexers::SQF.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.sqf'
    end
  end
end
