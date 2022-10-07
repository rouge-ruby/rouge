module Rouge
  module Lexers
    class APL < RegexLexer
      # Many rules taken from https://github.com/Alhadis/language-apl/blob/master/grammars/apl.cson
      title "APL"
      desc "APL, a tool of thought for array programming"
      tag 'apl'
      filenames '*.apl', '*.apla', '*.aplf', '*.aplo', '*.apln', '*.aplc', '*.apli', '*.mipage'
      mimetypes 'text/apl'

      def self.detect?(text)
        return true if text.shebang? 'apl'
      end

      state :root do
        rule %r/'/, Str::Single, :str
        rule %r/⍝.*/, Comment::Single
        rule %r/¯?[0-9][¯0-9A-Za-z]*(?:\.[¯0-9Ee][¯0-9A-Za-z]*)*|¯?\.[0-9Ee][¯0-9A-Za-z]/, Num::Number
        rule %r/(?x)^\s*([A-Z_a-zÀ-ÖØ-Ýßà-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýßà-öø-üþ∆⍙Ⓐ-Ⓩ¯0-9]*)(:)/, Name::Label
        rule %r'[+×÷⌊⌈⍟○!∧∨⍲⍱<≤=≥>≠?⍷,⍪⌷⍳⍴↑↓⊣⊢⊤⊥\/⌿⍀⌽⊖⍉⍋⍒⌹≡≢⊂⊃∩∪⍎⍕⊆⍸]', Keyword
        rule %r/[¨⍤⌸⍨⍣\\.∘⍠&⌶⌺@]/, Operator
        rule %r/[⍺⍵⍶⍹χ∇λ]/, Keyword::Variable
        rule %r/◊;¯←→\[\]\{\}\(\)/, Punctuation
        rule %r/[A-Z_a-zÀ-ÖØ-Ýßà-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýßà-öø-üþ∆⍙Ⓐ-Ⓩ¯0-9]*/, Name::Variable
        rule %/\s+/, Text
      end

      state :str do
        rule %r/''/, Str::Escape
        rule %r/[^'\n]+/, Str::Single
        rule %r/'|$/, Str::Single, :pop!
      end

    end
  end
end
