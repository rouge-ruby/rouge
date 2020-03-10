# frozen_string_literal: true

describe Rouge::Lexers::Prometheus do
  let(:subject) { Rouge::Lexers::Prometheus.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.prometheus'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-prometheus'
      assert_guess :mimetype => 'application/x-prometheus'
    end
  end
end

