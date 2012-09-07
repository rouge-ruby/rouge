describe Rouge::Lexers::Javascript do
  let(:subject) { Rouge::Lexers::Javascript.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.js'
      assert_guess Rouge::Lexers::JSON, :filename => 'foo.json'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/javascript'
      assert_guess Rouge::Lexers::JSON, :mimetype => 'application/json'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/bin/env node'
      assert_guess :source => '#!/usr/local/bin/jsc'
      assert_guess Rouge::Lexers::JSON, :source => '{ "foo": "bar" }'
    end
  end
end
