# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Themes
    class Dracula < CSSTheme
      name 'dracula'

      palette :Foreground => "#f8f8f2"
      palette :Background => "#282a36"
      palette :CurrentLine => "#44475a"
      palette :Selection => "#44475a"
      palette :Comment => "#6272a4"
      palette :Cyan => "#8be9fd"
      palette :Green => "#50fa7b"
      palette :Orange => "#ffb86c"
      palette :Pink => "#ff79c6"
      palette :Purple => "#bd93f9"
      palette :Red => "#ff5555"
      palette :Yellow => "#f1fa8c"

      style Text, :fg => :Foreground, :bg => :Background

      style Comment, :fg => :Comment
      style Comment::Preproc, :fg => :Pink

      style Generic::Deleted, :fg => '#8b080b'
      style Generic::Output, :fg => "#44475a"
      style Generic::Emph, :underline => true
      style Generic::Heading,
            Generic::Inserted,
            Generic::Subheading, :underline => true

      style Keyword, :fg => :Pink, :bold => true
      style Keyword::Declaration, :fg => :Cyan, :italic => true
      style Keyword::Type, :fg => :Cyan

      style Name::Attribute,
            Name::Class,
            Name::Function, :fg => :Green
      style Name::Variable,
            Name::Label,
            Name::Builtin, :fg => :Cyan, :italic => true

      style Str, :fg => :Yellow
      style Num, :fg => :Purple
      style Operator, :fg => :Pink

    end
  end
end
