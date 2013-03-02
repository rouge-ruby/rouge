module Rouge
  module Lexers
    class Lua < RegexLexer
      desc "Lua (http://www.lua.org)"
      tag 'lua'
      filenames '*.lua', '*.wlua'
      
      mimetypes 'text/x-lua', 'application/x-lua'
      
      def self.analyze_text(text)
        return 1 if text.shebang? 'lua'
      end
   
      state :root do
        rule %r(--\[(=*)\[.*?\]\1\])ms, 'Comment.Multiline'
        rule %r(--.*$), 'Comment.Single'
        
        rule %r((?i)(\d*\.\d+|\d+\.\d*)(e[+-]?\d+)?'), 'Literal.Number.Float'
        rule %r((?i)\d+e[+-]?\d+), 'Literal.Number.Float'
        rule %r((?i)0x[0-9a-f]*), 'Literal.Number.Hex'
        rule %r(\d+), 'Literal.Number.Integer'
        
        rule %r(\n), 'Text'
        rule %r([^\S\n]), 'Text'
        # multiline strings
        rule %r(\[(=*)\[.*?\]\1\])ms, 'Literal.String'
        
        rule %r((==|~=|<=|>=|\.\.\.|\.\.|[=+\-*/%^<>#])), 'Operator'
        rule %r([\[\]\{\}\(\)\.,:;]), 'Punctuation'
        rule %r((and|or|not)\b), 'Operator.Word'
        
        rule %r((break|do|else|elseif|end|for|if|in|repeat|return|then|until|while)\b), 'Keyword'
        rule %r((local)\b), 'Keyword.Declaration'
        rule %r((true|false|nil)\b), 'Keyword.Constant'
        
        rule %r((function)\b), 'Keyword', :function_name
        
        rule %r([A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?), 'Name'
        
        rule %r('), 'Literal.String.Single' # combined(:string_escape, :sqs)
        rule %r("), 'Literal.String.Double' # combined(:string_escape, :dqs)
      end
      
      state :function_name do
        rule /\s+/, 'Text'
        rule %r((?:([A-Za-z_][A-Za-z0-9_]*)(\.))?([A-Za-z_][A-Za-z0-9_]*)) do
          group 'Name.Class'; group 'Name.Punctuation'; group 'Name.Function'
          pop!
        end
        # inline function
        rule %r(\(), 'Punctuation', :pop!
      end
      
      state :string_escape do
        rule %r('\\([abfnrtv\\"']|\d{1,3})'), 'Literal.String.Escape'
      end
      
      state :sqs do
        rule %r('), 'Literal.String', :pop!
        # include('string')
      end
      
      state :dqs do
        rule %r("), 'Literal.String', :pop!
        # include('string')
      end
      
    end
  end
end