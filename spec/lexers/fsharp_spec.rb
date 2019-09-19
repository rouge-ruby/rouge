# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::FSharp do
  let(:subject) { Rouge::Lexers::FSharp.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.fs'
      assert_guess :filename => 'foo.fsx'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/fsharp-script'
	    assert_guess :mimetype => 'text/x-fsharp'
	    assert_guess :mimetype => 'text/x-fsi'
    end
  end
end