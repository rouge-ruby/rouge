# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Dart do
  let(:subject) { Rouge::Lexers::Dart.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.dart'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-dart'
    end
  end
end
