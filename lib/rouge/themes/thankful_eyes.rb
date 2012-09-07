module Rouge
  module Themes
    class ThankfulEyes < CSSTheme
      name 'thankful_eyes'

      # pallette, from GTKSourceView's ThankfulEyes
      palette :cool_as_ice    => '#6c8b9f'
      palette :slate_blue     => '#4e5d62'
      palette :eggshell_cloud => '#dee5e7'
      palette :krasna         => '#122b3b'
      palette :aluminum1      => '#fefeec'
      palette :scarletred2    => '#cc0000'
      palette :butter3        => '#c4a000'
      palette :go_get_it      => '#b2fd6d'
      palette :chilly         => '#a8e1fe'
      palette :unicorn        => '#faf6e4'
      palette :sandy          => '#f6dd62'
      palette :pink_merengue  => '#f696db'
      palette :dune           => '#fff0a6'
      palette :backlit        => '#4df4ff'
      palette :schrill        => '#ffb000'

      style 'Text', :fg => :unicorn, :bg => :krasna

      style 'Comment', :fg => :cool_as_ice, :italic => true
      style 'Error',
            'Generic.Error', :fg => :aluminum1, :bg => :scarletred2
      style 'Keyword', :fg => :sandy, :bold => true
      style 'Operator',
            'Punctuation', :fg => :backlit, :bold => true
      style 'Generic.Deleted', :fg => :scarletred2
      style 'Generic.Inserted', :fg => :go_get_it
      style 'Generic.Emph', :italic => true
      style 'Generic.Subheading', :fg => '#800080', :bold => true
      style 'Generic.Traceback', :fg => '#0040D0'
      style 'Keyword.Constant', :fg => :pink_merengue, :bold => true
      style 'Keyword.Namespace',
            'Keyword.Pseudo',
            'Keyword.Reserved',
            'Generic.Heading', :fg => :schrill, :bold => true
      style 'Keyword.Type',
            'Name.Constant',
            'Name.Class',
            'Name.Decorator',
            'Name.Namespace',
            'Name.Builtin.Pseudo',
            'Name.Exception',
            'Name.Tag', :fg => :go_get_it, :bold => true
      style 'Literal.Number', :fg => :pink_merengue, :bold => true
      style 'Literal.String', :fg => :dune, :bold => true
      style 'Literal.String.Escape',
            'Literal.String.Char',
            'Literal.String.Interpol',
            'Literal.String.Other',
            'Literal.String.Symbol', :fg => :backlit, :bold => true
      style 'Name.Builtin', :fg => :sandy
      style 'Name.Entity', :fg => '#999999', :bold => true
      style 'Text.Whitespace', :fg => '#BBBBBB'
      style 'Name.Variable',
            'Name.Function',
            'Name.Label',
            'Name.Attribute', :fg => :chilly
    end
  end
end
