# -*- coding: utf-8 -*- #

describe Rouge::Lexers::RAML do
  let(:subject) { Rouge::Lexers::RAML.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'bar.raml'
    end


  end

end
