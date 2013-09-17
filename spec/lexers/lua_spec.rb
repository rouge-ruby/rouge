describe Rouge::Lexers::Lua do
  let(:subject) { Rouge::Lexers::Lua.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.lua'
      assert_guess :filename => 'foo.wlua'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-lua'
      assert_guess :mimetype => 'application/x-lua'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/usr/local/bin/lua'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes the demo with no errors' do
      assert_no_errors(lexing_demo)
    end

    it 'lexes the sample without throwing' do
      lex_sample.to_a
    end
  end
end
