module Rouge
  module Lexers
    class Properties < RegexLexer
      desc '.properties file mainly used in Java related technologies to store the configurable parameters of an application or localisation data'
      tag 'properties'

      filenames '*.properties'
      mimetypes 'text/x-java-properties'

      def self.analyze_text(text)
        return 0.1 if text =~ /\A\[[\w.]+\]\s*\w+=\w+/
      end

      identifier = /[\w.]+/

      state :basic do
        rule /[!#].*?\n/, Comment
        rule /\s+/, Text
        rule /\\\n/, Str::Escape
      end

      state :root do
        mixin :basic

        rule /(#{identifier})(\s*)([=:])/ do
          groups Name::Property, Text, Punctuation
          push :value
        end
      end

      state :value do
        rule /\n/, Text, :pop!
        mixin :basic
        rule /"/, Str, :dq
        rule /'.*?'/, Str
        mixin :esc_str
        rule /[^\\\n]+/, Str
      end

      state :dq do
        rule /"/, Str, :pop!
        mixin :esc_str
        rule /[^\\"]+/m, Str
      end

      state :esc_str do
        rule /\\./m, Str::Escape
      end
    end
  end
end
