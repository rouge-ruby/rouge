module Rouge
  module Lexers
    class INI < RegexLexer
      desc 'the INI configuration format'
      tag 'ini'

      # TODO add more here
      filenames '*.ini', '*.INI', '*.gitconfig'
      mimetypes 'text/x-ini'

      def self.analyze_text(text)
        return 0.1 if text =~ /\A\[[\w.]+\]\s*\w+=\w+/
      end

      identifier = /[\w.]+/

      state :basic do
        rule /[;#].*?\n/, 'Comment'
        rule /\s+/, 'Text'
        rule /\\\n/, 'Literal.String.Escape'
      end

      state :root do
        mixin :basic

        rule /(#{identifier})(\s*)(=)/ do
          group 'Name.Property'; group 'Text'
          group 'Punctuation'
          push :value
        end

        rule /\[.*?\]/, 'Name.Namespace'
      end

      state :value do
        rule /\n/, 'Text', :pop!
        mixin :basic
        rule /"/, 'Literal.String', :dq
        rule /'.*?'/, 'Literal.String'
        mixin :esc_str
        rule /[^\\\n]+/, 'Literal.String'
      end

      state :dq do
        rule /"/, 'Literal.String', :pop!
        mixin :esc_str
        rule /[^\\"]+/m, 'Literal.String'
      end

      state :esc_str do
        rule /\\./m, 'Literal.String.Escape'
      end
    end
  end
end
