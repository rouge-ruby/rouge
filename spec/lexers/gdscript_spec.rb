# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GDScript do
  let(:subject) { Rouge::Lexers::GDScript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.gd'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-gdscript'
      assert_guess :mimetype => 'application/x-gdscript'
    end
  end
end
