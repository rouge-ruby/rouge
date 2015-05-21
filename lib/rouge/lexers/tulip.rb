module Rouge
  module Lexers
    class Tulip < RegexLexer
      tag 'tulip'
      aliases 'tlp'
      filenames '*.tlp'
      desc 'The tulip programming language http://github.com/jneen/tulip'

      id = /\w[\w-]*/

      def self.analyze_text(text)
        return 1 if text.shebang?('tulip')
      end

      state :root do
        rule /\s+/, Text
        rule /#.*?\n/, Comment
        rule /%#{id}/, Keyword::Type
        rule /@#{id}/, Keyword
        rule /[.][.]?#{id}/, Name::Label
        rule /-#{id}[?]?/, Str::Symbol
        rule /\d+/, Num
        rule %r(/#{id}?), Name::Decorator
        rule %r((#{id}/)(#{id})) do
          groups Name::Namespace, Name::Variable
        end

        rule /"{/, Str, :string_interp
        rule /'?{/, Str, :string
        rule /['"][^\s)\]]+/, Str

        rule /[$]/, Name::Variable

        rule /[-+:;~!()\[\]=?>|_%,]/, Punctuation
        rule /[.][.][.]/, Punctuation
        rule id, Name
      end

      state :string_base do
        rule /{/ do
          token Str; push
        end

        rule /}/, Str, :pop!
        rule /[$]/, Str
        rule /[^${}\\]+/, Str
      end

      state :string do
        mixin :string_base
        rule /\\/, Str
      end

      state :interp do
        rule(/[(]/) { token Punctuation; push }
        rule /[)]/, Punctuation, :pop!
        mixin :root
      end

      state :interp_root do
        rule /[(]/, Str::Interpol, :interp
        rule /[)]/, Str::Interpol, :pop!
        mixin :root
      end

      state :string_interp do
        rule /\\./, Str::Escape
        rule /[$][(]/, Str::Interpol, :interp_root
        rule /[$]#{id}?/, Name::Variable
        mixin :string_base
      end
    end
  end
end

