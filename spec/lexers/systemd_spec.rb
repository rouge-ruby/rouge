# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::SystemD do
  let(:subject) { Rouge::Lexers::SystemD::new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'unit.service'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-systemd-unit'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'handles continuations without quotes' do
      systemd_file = <<~SYSTEMD
        [Service]
        ExecStart=/exec \\
                  without-a-quote
      SYSTEMD

      assert_no_errors systemd_file
      assert_tokens_equal systemd_file,
        ['Keyword', '[Service]'],
        ['Text', "\n"],
        ['Name.Tag', 'ExecStart'],
        ['Punctuation', '='],
        ['Text', '/exec '],
        ['Literal.String.Escape', "\\\n"],
        ['Text', "          without-a-quote\n"]
    end
  end
end
