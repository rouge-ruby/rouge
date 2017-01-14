# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Robot do
  let(:subject) { Rouge::Lexers::Robot.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.robot'
    end

    it 'guesses by source' do
      assert_guess :source => '*** Settings ***'
    end
  end
end
