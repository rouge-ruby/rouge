module Rouge
  module Lexers
    class APL < RegexLexer
      title "APL"
      desc "APL, a tool of thought for array processing"
      tag 'apl'
      filenames '*.apl', '*.apla', '*.aplf', '*.aplo', '*.apln', '*.aplc', '*.apli', '*.mipage'
      mimetypes 'text/apl'

      def self.detect?(text)
        return true if text.shebang? 'apl'
      end

      state :root do
        rule %r/'/, Str::Single, :str
        rule %r/⍝.*/, Comment::Single
      end

      state :str do
        rule %r/''/, Str::Escape
        rule %r/[^'\n]+/, Str::Single
        rule %r/'|$/, Str::Single, :pop!
      end

    end
  end
end
