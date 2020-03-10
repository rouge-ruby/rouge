# frozen_string_literal: true

describe Rouge::Lexers::Apache do
  let(:subject) { Rouge::Lexers::Apache.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => '.htaccess'
      assert_guess :filename => 'httpd.conf'
      deny_guess   :filename => 'foo.conf'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-apache-conf'
      assert_guess :mimetype => 'text/x-httpd-conf'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'does not drop non directives' do
      assert_tokens_equal 'foo bar', ['Text', 'foo bar']
    end

    it 'lexes case insensitively directives' do
      assert_tokens_equal 'setenv foo bar', ['Name.Class', 'setenv'], ['Text', ' foo bar']
    end

    it 'recognizes one line comment on last line even when not terminated by a new line (#360)' do
      assert_tokens_equal '# comment', ['Comment', '# comment']
    end
  end
end
