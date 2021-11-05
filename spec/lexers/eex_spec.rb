# -*- coding: utf-8 -*- #

describe Rouge::Lexers::EEX do
  let(:subject) { Rouge::Lexers::EEX.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.eex'
      assert_guess :filename => 'foo.html.eex'
      assert_guess :filename => 'foo.html.leex'
      assert_guess :filename => 'foo.html.heex'
    end
  end
end
