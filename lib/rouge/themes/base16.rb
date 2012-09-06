module Rouge
  module Themes
    # default base16 theme
    # by Chris Kempson (http://chriskempson.com)
    class Base16 < CSSTheme
      name 'base16'

      palette base00: "#151515"
      palette base01: "#202020"
      palette base02: "#303030"
      palette base03: "#505050"
      palette base04: "#b0b0b0"
      palette base05: "#d0d0d0"
      palette base06: "#e0e0e0"
      palette base07: "#f5f5f5"
      palette base08: "#ac4142"
      palette base09: "#d28445"
      palette base0A: "#f4bf75"
      palette base0B: "#90a959"
      palette base0C: "#75b5aa"
      palette base0D: "#6a9fb5"
      palette base0E: "#aa759f"
      palette base0F: "#8f5536"

      style 'Text', :fg => :base02
      style 'Error', :fg => :base00, :bg => :base08
      style 'Comment', :fg => :base03

      style 'Comment.Preproc',
            'Name.Tag', :fg => :base0A

      style 'Operator',
            'Punctuation', :fg => :base05

      style 'Generic.Inserted', :fg => :base0B
      style 'Generic.Removed', :fg => :base08
      style 'Generic.Heading', :fg => :base0D, :bg => :base00, :bold => true

      style 'Keyword', :fg => :base0E
      style 'Keyword.Constant',
            'Keyword.Type', :fg => :base09

      style 'Keyword.Declaration', :fg => :base09

      style 'Literal.String', :fg => :base0B
      style 'Literal.String.Regex', :fg => :base0C

      style 'Literal.String.Interpol',
            'Literal.String.Escape', :fg => :base0F

      style 'Name.Namespace',
            'Name.Class',
            'Name.Constant', :fg => :base0A

      style 'Name.Attribute', :fg => :base0D

      style 'Literal.Number',
            'Literal.String.Symbol', :fg => :base0B
    end
  end
end
