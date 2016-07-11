module Rouge
  module Lexers
    class Tulip < RegexLexer
      desc 'the tulip programming language (twitter.com/tuliplang)'
      tag 'tulip'
      aliases 'tulip'

      filenames '*.tlp'

      mimetypes 'text/x-tulip', 'application/x-tulip'

      def self.analyze_text(text)
        return 1 if text.shebang? 'tulip'
        return 0
      end

      id = /[a-z][\w-]*/i
      upper_id = /[A-Z][\w-]*/

      state :root do
        rule /\s+/, Text
        rule /@#{id}/, Keyword


        rule /[>,!\[\]:{}()=;\/]/, Punctuation

        rule /(\\#{id})([{])/ do
          groups Name::Variable, Str
          push :nested_string
        end

        rule /\\#{id}/, Name::Function

        rule /'{/, Str, :nested_string

        rule /[.]#{id}/, Name::Tag
        rule /[$]#{id}/, Name::Variable

        rule /[0-9]+([.][0-9]+)?/, Num

        rule /#{id}/, Name

        rule /</, Comment::Preproc, :angle_brackets
      end

      state :nested_string do
        rule /\\./, Str::Escape
        rule(/{/) { token Str; push :nested_string }
        rule(/}/) { token Str; pop! }
        rule(/./) { token Str }
      end

      state :angle_brackets do
        rule />/, Comment::Preproc, :pop!
        rule /[*:]/, Punctuation
        rule /#{upper_id}/, Keyword::Type
        rule /#{id}/, Name::Variable
      end
    end
  end
end

