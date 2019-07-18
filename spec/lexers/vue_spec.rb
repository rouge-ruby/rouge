# frozen_string_literal: true

describe Rouge::Lexers::Vue do
  let(:subject) { Rouge::Lexers::Vue.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.vue'
    end
  end
end

