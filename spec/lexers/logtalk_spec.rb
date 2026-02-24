# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Logtalk do
  let(:subject) { Rouge::Lexers::Logtalk.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.lgt'
      assert_guess :filename => 'foo.logtalk'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-logtalk'
    end

  end
end
