describe Rouge::Lexers::Javascript do
  let(:subject) { Rouge::Lexers::Javascript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.js'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/javascript'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env node'
      assert_guess :source => '#!/usr/local/bin/jsc'
    end
  end
end
