# frozen_string_literal: true

describe Rouge::Lexers::APIBlueprint do
  let(:subject) { Rouge::Lexers::APIBlueprint.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.apib'
    end
  end
end
