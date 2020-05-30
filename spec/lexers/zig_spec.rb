# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Zig do
  let(:subject) { Rouge::Lexers::Zig.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.zig'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-zig'
    end
  end

  describe 'lexing' do
    include Support::Lexing;
  end
end
