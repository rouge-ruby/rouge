# -*- coding: utf-8 -*- #

module Rouge
  module Themes
    class Github < CSSTheme
      name 'isbl_editor_dark'

      style Comment::Multiline,               :fg => '#b5b5b5', :italic => true
      style Comment::Preproc,                 :fg => '#b5b5b5', :bold => true
      style Comment::Single,                  :fg => '#b5b5b5', :italic => true
      style Comment::Special,                 :fg => '#b5b5b5', :italic => true, :bold => true
      style Comment,                          :fg => '#b5b5b5', :italic => true
      style Error,                            :fg => '#aa0000'
      style Generic::Deleted,                 :fg => '#888888'
      style Generic::Emph,                    :fg => '#888888'
      style Generic::Error,                   :fg => '#aa0000'
      style Generic::Heading,                 :fg => '#999999'
      style Generic::Inserted,                :fg => '#888888'
      style Generic::Output,                  :fg => '#aa0000'
      style Generic::Prompt,                  :fg => '#555555'
      style Generic::Strong,                  :bold => true
      style Generic::Subheading,              :fg => '#aaaaaa'
      style Generic::Traceback,               :fg => '#aa0000'
      style Keyword::Constant,                :fg => '#66d9ef'
      style Keyword::Declaration,             :fg => '#66d9ef'
      style Keyword::Namespace,               :fg => '#f0f0f0'
      style Keyword::Pseudo,                  :fg => '#f0f0f0'
      style Keyword::Reserved,                :fg => '#66d9ef'
      style Keyword::Type,                    :fg => '#f0f0f0'
      style Keyword,                          :fg => '#f0f0f0', :bold => true
      style Literal::Number::Float,           :fg => '#ae81ff'
      style Literal::Number::Hex,             :fg => '#ae81ff'
      style Literal::Number::Integer::Long,   :fg => '#ae81ff'
      style Literal::Number::Integer,         :fg => '#ae81ff'
      style Literal::Number::Oct,             :fg => '#ae81ff'
      style Literal::Number,                  :fg => '#f0f0f0'
      style Literal::String::Backtick,        :fg => '#97bf0d'
      style Literal::String::Char,            :fg => '#ae81ff'
      style Literal::String::Doc,             :fg => '#97bf0d'
      style Literal::String::Double,          :fg => '#97bf0d'
      style Literal::String::Escape,          :fg => '#ae81ff'
      style Literal::String::Heredoc,         :fg => '#97bf0d'
      style Literal::String::Interpol,        :fg => '#97bf0d'
      style Literal::String::Other,           :fg => '#97bf0d'
      style Literal::String::Regex,           :fg => '#009926'
      style Literal::String::Single,          :fg => '#97bf0d'
      style Literal::String::Symbol,          :fg => '#ae81ff'
      style Literal::String,                  :fg => '#97bf0d'
      style Name::Attribute,                  :fg => '#a6e22e'
      style Name::Builtin::Pseudo,            :fg => '#f0f0f0'
      style Name::Builtin,                    :fg => '#97bf0d', :bold => true
      style Name::Class,                      :fg => '#a6e22e'
      style Name::Constant,                   :fg => '#f0f0f0'
      style Name::Decorator,                  :fg => '#a6e22e'
      style Name::Entity,                     :fg => '#f0f0f0'
      style Name::Exception,                  :fg => '#a6e22e'
      style Name::Function,                   :fg => '#81bce9'
      style Name::Label,                      :fg => '#f0f0f0', :bold => true
      style Name::Namespace,                  :fg => '#f0f0f0'
      style Name::Tag,                        :fg => '#f92672'
      style Name::Variable::Class,            :fg => '#f0f0f0'
      style Name::Variable::Global,           :fg => '#ce9d4d', :bold => true
      style Name::Variable::Instance,         :fg => '#f0f0f0'
      style Name::Variable,                   :fg => '#e2c696'
      style Name,                             :fg => '#f0f0f0'
      style Operator::Word,                   :fg => '#f0f0f0', :bold => true
      style Operator,                         :fg => '#f0f0f0'
      style Text::Whitespace,                 :fg => '#f0f0f0'
      style Text,                             :fg => '#f0f0f0', :bg => '#404040'
    end
  end
end
