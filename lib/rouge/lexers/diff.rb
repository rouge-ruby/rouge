module Rouge
  module Lexers
    class Diff < RegexLexer
      tag 'diff'
      aliases 'patch'
      extensions 'diff', 'patch'

      state :header do
        rule /^diff .*?\n(?=---|\+\+\+)/m, 'Generic.Heading'
        rule /^--- .*?\n/, 'Generic.Deleted'
        rule /^\+\+\+ .*?\n/, 'Generic.Inserted'
      end

      state :diff do
        rule /@@ -\d+,\d+ \+\d+,\d+ @@.*?\n/, 'Generic.Heading'
        rule /^\+.*?\n/, 'Generic.Inserted'
        rule /^-.*?\n/,  'Generic.Deleted'
        rule /^ .*?\n/,  'Text'
        rule /^.*?\n/,   'Error'
      end

      state :root do
        mixin :header
        mixin :diff
      end
    end
  end
end
