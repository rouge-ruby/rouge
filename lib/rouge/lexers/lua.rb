module Rouge
  module Lexers
    class Lua < RegexLexer
      desc "Lua (http://www.lua.org)"
      tag 'lua'
      filenames '*.lua', '*.wlua'
      
      mimetypes 'text/x-lua', 'application/x-lua'
      
      def initialize(opts={})
        @function_highlighting = opts.delete(:function_highlighting) { true }
        @disabled_modules = opts.delete(:disabled_modules) { [] }
        super(opts)
      end
      
      def self.analyze_text(text)
        return 1 if text.shebang? 'lua'
      end
      
      def self.builtins
        load Pathname.new(__FILE__).dirname.join('lua/builtins.rb')
        self.builtins
      end
   
      def builtins
        return [] unless @function_highlighting

        @builtins ||= Set.new.tap do |builtins|
          self.class.builtins.each do |mod, fns|
            next if @disabled_modules.include? mod
            builtins.merge(fns)
          end
        end
      end
      
      state :root do
        # lua allows a file to start with a shebang
        rule %r(#!(.*?)$), 'Comment.Preproc'
        rule //, 'Text', :base
      end
                  
      state :base do
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
        
        rule %r([A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?) do |m|
          name = m[0]
          if self.builtins.include?(name)
            token 'Name.Builtin'
          elsif name =~ /\./
            a, b = name.split('.', 2)
            token 'Name', a
            token 'Punctuation', '.'
            token 'Name', b
          else
            token 'Name'
          end
        end
        
        rule %r('), 'Literal.String.Single', :escape_sqs
        rule %r("), 'Literal.String.Double', :escape_dqs
      end
      
      state :function_name do
        rule /\s+/, 'Text'
        rule %r((?:([A-Za-z_][A-Za-z0-9_]*)(\.))?([A-Za-z_][A-Za-z0-9_]*)) do
          group 'Name.Class'; group 'Punctuation'; group 'Name.Function'
          pop!
        end
        # inline function
        rule %r(\(), 'Punctuation', :pop!
      end
      
      state :escape_sqs do
        mixin :string_escape
        mixin :sqs
      end
      
      state :escape_dqs do
        mixin :string_escape
        mixin :dqs
      end
      
      state :string_escape do
        rule %r(\\([abfnrtv\\"']|\d{1,3})), 'Literal.String.Escape'
      end
      
      state :sqs do
        rule %r('), 'Literal.String', :pop!
        mixin :string
      end
      
      state :dqs do
        rule %r("), 'Literal.String', :pop!
        mixin :string
      end
      
      # Lua is 8-bit clean, every character is valid in a string
      state :string do
        rule /./, 'Literal.String'
      end
      
    end
  end
end