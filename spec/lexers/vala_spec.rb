# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Vala do
  let(:subject) { Rouge::Lexers::Vala.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.vala'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-vala'
    end
  end
end
