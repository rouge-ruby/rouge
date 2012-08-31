module Rouge
  class Token
    attr_reader :name
    attr_reader :parent

    def make_single(name)
      name = name.to_s
      new_name = [self.name, name].compact.join('.')

      new_token = self.clone
      parent = self
      new_token.instance_eval do
        @name = new_name
        @parent = parent
        @sub_tokens = {}
      end

      sub_tokens[name] = new_token

      new_token
    end

    def make(name)
      names = name.split('.')
      names.inject(self) do |tok, name|
        tok.make_single(name)
      end
    end

    def [](name)
      name = name.to_s

      name.split('.').inject(self) do |tok, name|
        tok.sub_tokens[name] || tok.make_single(name)
      end
    end

    def sub_tokens
      @sub_tokens ||= {}
    end

    def ===(other)
      immediate = if self.class == other.class
        self == other
      else
        self.name == other
      end

      immediate || !!(other.parent && self === other.parent)
    end

    def inspect
      "#<Token #{name}>"
    end

    class << self
      def get(name)
        Token[name]
      end
      alias [] get
    end

    Token       = new
    Text        = Token[:Text]
    Whitespace  = Token[:Whitespace]
    Error       = Token[:Error]

    Keyword     = Token[:Keyword]
    Name        = Token[:Name]
    Literal     = Token[:Literal]
    String      = Literal[:String]
    Number      = Literal[:Number]
    Punctuation = Token[:Punctuation]
    Operator    = Token[:Operator]
    Comment     = Token[:Comment]
  end
end
