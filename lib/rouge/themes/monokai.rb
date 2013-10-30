module Rouge
  module Themes
    class Monokai < CSSTheme
      name 'monokai'

      style Comment::Multiline,               :fg => '#75715e', :italic => true
      style Comment::Preproc,                 :fg => '#75715e', :bold => true
      style Comment::Single,                  :fg => '#75715e', :italic => true
      style Comment::Special,                 :fg => '#75715e', :italic => true, :bold => true
      style Comment,                          :fg => '#75715e', :italic => true
      style Error,                            :fg => '#960050', :bg => '#1e0010'
      style Generic::Deleted,                 :fg => '#000000'
      style Generic::Emph,                    :fg => '#000000', :italic => true
      style Generic::Error,                   :fg => '#aa0000'
      style Generic::Heading,                 :fg => '#999999'
      style Generic::Inserted,                :fg => '#000000'
      style Generic::Output,                  :fg => '#888888'
      style Generic::Prompt,                  :fg => '#555555'
      style Generic::Strong,                  :bold => true
      style Generic::Subheading,              :fg => '#aaaaaa'
      style Generic::Traceback,               :fg => '#aa0000'
      style Keyword::Constant,                :fg => '#66d9ef', :bold => true
      style Keyword::Declaration,             :fg => '#66d9ef', :bold => true
      style Keyword::Namespace,               :fg => '#f92672', :bold => true
      style Keyword::Pseudo,                  :fg => '#66d9ef', :bold => true
      style Keyword::Reserved,                :fg => '#66d9ef', :bold => true
      style Keyword::Type,                    :fg => '#66d9ef', :bold => true
      style Keyword,                          :fg => '#66d9ef', :bold => true
      style Literal::Number::Float,           :fg => '#ae81ff'
      style Literal::Number::Hex,             :fg => '#ae81ff'
      style Literal::Number::Integer::Long,   :fg => '#ae81ff'
      style Literal::Number::Integer,         :fg => '#ae81ff'
      style Literal::Number::Oct,             :fg => '#ae81ff'
      style Literal::Number,                  :fg => '#ae81ff'
      style Literal::String::Backtick,        :fg => '#e6db74'
      style Literal::String::Char,            :fg => '#e6db74'
      style Literal::String::Doc,             :fg => '#e6db74'
      style Literal::String::Double,          :fg => '#e6db74'
      style Literal::String::Escape,          :fg => '#ae81ff'
      style Literal::String::Heredoc,         :fg => '#e6db74'
      style Literal::String::Interpol,        :fg => '#e6db74'
      style Literal::String::Other,           :fg => '#e6db74'
      style Literal::String::Regex,           :fg => '#e6db74'
      style Literal::String::Single,          :fg => '#e6db74'
      style Literal::String::Symbol,          :fg => '#e6db74'
      style Literal::String,                  :fg => '#e6db74'
      style Name::Attribute,                  :fg => '#a6e22e'
      style Name::Builtin::Pseudo,            :fg => '#f8f8f2'
      style Name::Builtin,                    :fg => '#f8f8f2'
      style Name::Class,                      :fg => '#a6e22e', :bold => true
      style Name::Constant,                   :fg => '#66d9ef'
      style Name::Decorator,                  :fg => '#a6e22e', :bold => true
      style Name::Entity,                     :fg => '#f8f8f2'
      style Name::Exception,                  :fg => '#a6e22e', :bold => true
      style Name::Function,                   :fg => '#a6e22e', :bold => true
      style Name::Label,                      :fg => '#f8f8f2', :bold => true
      style Name::Namespace,                  :fg => '#f8f8f2'
      style Name::Tag,                        :fg => '#f92672'
      style Name::Variable::Class,            :fg => '#f8f8f2'
      style Name::Variable::Global,           :fg => '#f8f8f2'
      style Name::Variable::Instance,         :fg => '#f8f8f2'
      style Name::Variable,                   :fg => '#f8f8f2'
      style Operator::Word,                   :fg => '#f92672', :bold => true
      style Operator,                         :fg => '#f92672', :bold => true
      style Text::Whitespace,                 :fg => '#f8f8f2'
      style Text,                             :fg => "#f8f8f2", :bg => '#49483e'
    end
  end
end
