# -*- coding: utf-8 -*- #

describe Rouge::Lexers::RobotFramework do
  let(:subject) { Rouge::Lexers::RobotFramework.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.robot'
    end
  end
end
