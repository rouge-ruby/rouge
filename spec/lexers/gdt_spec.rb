# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GDT do
  let(:subject) { Rouge::Lexers::GDT.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gdt'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gdt'
    end
  end
end
