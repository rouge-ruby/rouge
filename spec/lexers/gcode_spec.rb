# -*- coding: utf-8 -*- #

describe Rouge::Lexers::GCode do
  let(:subject) { Rouge::Lexers::GCode.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess   :filename => 'foo.gcode'
    end
  end
end
