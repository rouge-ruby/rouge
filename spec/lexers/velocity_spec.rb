# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Velocity do
  let(:subject) { Rouge::Lexers::Velocity.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.velocity'
      assert_guess :filename => 'foo.vm'
      assert_guess :filename => 'foo.fhtml'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/html+velocity'
    end
  end
end
