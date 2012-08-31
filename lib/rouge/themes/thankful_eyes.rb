module Rouge
  module Themes
    class ThankfulEyes < CSSTheme
      # pallette, from GTKSourceView's ThankfulEyes
      cool_as_ice =    '#6c8b9f'
      slate_blue =     '#4e5d62'
      eggshell_cloud = '#dee5e7'
      krasna =         '#122b3b'
      aluminum1 =      '#fefeec'
      scarletred2 =    '#cc0000'
      butter3 =        '#c4a000'
      go_get_it =      '#b2fd6d'
      chilly =         '#a8e1fe'
      unicorn =        '#faf6e4'
      sandy =          '#f6dd62'
      pink_merengue =  '#f696db'
      dune =           '#fff0a6'
      backlit =        '#4df4ff'
      schrill =        '#ffb000'

      style :fg => unicorn, :bg => krasna

      style 'Comment', :fg => cool_as_ice
      style 'Error',
            'Generic.Error', :fg => aluminum1, :bg => scarletred2
      style 'Keyword', :fg => sandy, :bold => true
      style 'Operator', :fg => backlit, :bold => true
      style 'Comment.Preproc',
            'Comment.Multiline',
            'Comment.Single',
            'Comment.Special', :fg => cool_as_ice, :italic => true
      style 'Generic.Deleted', :fg => scarletred2
      style 'Generic.Emph', :italic => true
      style 'Generic.Subheading', :fg => '#800080', :bold => true
      style 'Generic.Traceback', :fg => '#0040D0'
      style 'Keyword.Constant', :fg => pink_merengue, :bold => true
      style 'Keyword.Namespace',
            'Keyword.Pseudo',
            'Keyword.Reserved', :fg => schrill, :bold => true
      style 'Keyword.Type',
            'Name.Constant',
            'Name.Class',
            'Name.Decorator',
            'Name.Namespace',
            'Name.Builtin.Pseudo',
            'Name.Exception', :fg => go_get_it, :bold => true
      style 'Literal.Number', :fg => pink_merengue, :bold => true
      style 'Literal.String', :fg => dune, :bold => true
      style 'Literal.String.Escape',
            'Literal.String.Char',
            'Literal.String.Interpol',
            'Literal.String.Other',
            'Literal.String.Symbol', :fg => backlit, :bold => true
      style 'Name.Attribute', :fg => '#7D9029'
      style 'Name.Builtin', :fg => sandy
      style 'Name.Entity', :fg => '#999999', :bold => true
      style 'Name.Label', :fg => '#A0A000'
      style 'Name.Tag', :fg => '#008000', :bold => true
      style 'Text.Whitespace', :fg => '#BBBBBB'
      style 'Name.Variable',
            'Name.Function', :fg => chilly

    end
  end
end
