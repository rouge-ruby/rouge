# -*- coding: utf-8 -*- #

describe Rouge::Lexers::EPP do
  let(:subject) { Rouge::Lexers::EPP.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.html.epp'
    end
  end
end
