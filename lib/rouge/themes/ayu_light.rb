# -*- coding: utf-8 -*- #

module Rouge
  module Themes
    # ayu light theme by Ike Ku:
    # https://github.com/ayu-theme/ayu-colors
    class AyuLight < CSSTheme
      name 'ayu_light'

      palette :accent => "#ff6a00"
      palette :foreground => "#6e7580"
      palette :background => "#fafafa"

      palette :error => "#f51818"

      palette :tag => "#55b4d4"
      palette :func => "#f29718"
      palette :entity => "#399ee6"
      palette :string => "#86b300"
      palette :regexp => "#4cbf99"
      palette :markup => "#f07171"
      palette :keyword => "#fa6e32"
      palette :special => "#e6b673"
      palette :comment => "#abb0b6"
      palette :constant => "#a37acc"
      palette :operator => "#ed9366"

      style Comment,
            Comment::Multiline,
            Comment::Single,                  :fg => :comment
      style Comment::Preproc,                 :fg => :comment
      style Comment::Special,                 :fg => :special
      style Error,                            :fg => :background, :bg => :error
      style Generic::Inserted,                :fg => :string
      style Generic::Deleted,                 :fg => :error
      style Generic::Emph,                    :italic => true
      style Generic::Error,
            Generic::Traceback,               :fg => :background, :bg => :error
      style Generic::Heading,                 :fg => :accent
      style Generic::Output,                  :fg => :foreground
      style Generic::Prompt,                  :fg => :foreground
      style Generic::Strong,                  :bold => true
      style Generic::Subheading,              :fg => :foreground
      style Keyword,
            Keyword::Constant,
            Keyword::Declaration,
            Keyword::Pseudo,
            Keyword::Reserved,
            Keyword::Type,                    :fg => :keyword
      style Keyword::Namespace,
            Operator::Word,
            Operator,                         :fg => :operator
      style Literal::Number::Float,
            Literal::Number::Hex,
            Literal::Number::Integer::Long,
            Literal::Number::Integer,
            Literal::Number::Oct,
            Literal::Number,
            Literal::String::Escape,          :fg => :constant
      style Literal::String::Backtick,
            Literal::String::Char,
            Literal::String::Doc,
            Literal::String::Double,
            Literal::String::Heredoc,
            Literal::String::Interpol,
            Literal::String::Other,
            Literal::String::Single,
            Literal::String,                  :fg => :string
      style Literal::String::Symbol,          :fg => :tag
      style Literal::String::Regex,           :fg => :regexp
      style Name::Attribute,                  :fg => :markup
      style Name::Class,
            Name::Decorator,
            Name::Exception,
            Name::Function,                   :fg => :func
      style Name::Constant,                   :fg => :constant
      style Name::Builtin::Pseudo,
            Name::Builtin,
            Name::Entity,
            Name::Namespace,
            Name::Variable::Class,
            Name::Variable::Global,
            Name::Variable::Instance,
            Name::Variable,
            Text::Whitespace,                 :fg => :entity
      style Name::Label,                      :fg => :entity
      style Name::Tag,                        :fg => :tag
      style Text,                             :fg => :foreground, :bg => :background
    end
  end
end
