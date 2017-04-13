module Rouge
  module Lexers
    class Q < RegexLexer
      title 'Q'
      desc 'The Q programming language (kx.com)'
      tag 'q'
      aliases 'q'
      filenames '*.q'
      mimetypes 'text/x-q', 'application/x-q'

      identifier = /\.?[a-z][a-z0-9_.]*/i

      def self.keywords
        @keywords ||= %w[abs til]
      end

      def self.analyze_text(text)
        return 0
      end

      state :root do
        rule /\n+/m, Text
        rule /#{identifier}/ do |m|
          if self.class.keywords.include? m[0]
            token Keyword
          else
            token Name
          end
        end

        rule(/[^\S\n]+/, Text)
        rule(%r{\/.*$}, Comment)

        rule(/0[nNwW][hijefcpmdznuvt]?/, Keyword::Constant)

        rule(/[0-9]+(\.[0-9]+)?[fe]/, Num::Float)
        rule(/[01]+b?/, Num)
        rule(/[0-9]+[hij]?/, Num::Integer)

        rule(/(?:<=|>=|<>|::)|[?:$%&|@._#*^\-+~,!><=]:?/, Operator)

        rule(/\\.*\n/, Text)

      end
    end
  end
end

