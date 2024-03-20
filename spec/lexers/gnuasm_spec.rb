# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::GnuAsm do
  let(:subject) { Rouge::Lexers::GnuAsm.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename and source hint' do
      assert_guess :filename => 'foo.s', :source => 'main: movq %rax, %rbx'
    end
  end
end
