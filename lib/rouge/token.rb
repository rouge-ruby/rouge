module Rouge
  class Token
    attr_reader :name
    attr_reader :parent
    attr_accessor :shortname
    alias to_s name

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

    def make(name, shortname=nil)
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

    def ancestors(&b)
      return enum_for(:ancestors) unless block_given?

      if parent
        yield self
        parent.ancestors(&b)
      end
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
      parts = [name.inspect]
      parts << shortname.inspect if shortname
      "#<Token #{parts.join(' ')}>"
    end

    class << self
      def base
        @base ||= new
      end

      def get(name)
        return name if name.is_a? Token

        base[name]
      end

      alias [] get

      def token(name, shortname)
        tok = get(name)
        tok.shortname = shortname
        tok
      end

      def each_token(&b)
        recurse = proc do |token|
          b.call(token)
          token.sub_tokens.each_value(&recurse)
        end

        base.sub_tokens.each_value(&recurse)
      end
    end

    # XXX IMPORTANT XXX
    # For compatibility, this list must be kept in sync with
    # pygments.token.STANDARD_TYPES
    # please see https://github.com/jayferd/rouge/wiki/List-of-tokens
    token 'Text',                        ''
    token 'Text.Whitespace',             'w'
    token 'Error',                       'err'
    token 'Other',                       'x'

    token 'Keyword',                     'k'
    token 'Keyword.Constant',            'kc'
    token 'Keyword.Declaration',         'kd'
    token 'Keyword.Namespace',           'kn'
    token 'Keyword.Pseudo',              'kp'
    token 'Keyword.Reserved',            'kr'
    token 'Keyword.Type',                'kt'

    token 'Name',                        'n'
    token 'Name.Attribute',              'na'
    token 'Name.Builtin',                'nb'
    token 'Name.Builtin.Pseudo',         'bp'
    token 'Name.Class',                  'nc'
    token 'Name.Constant',               'no'
    token 'Name.Decorator',              'nd'
    token 'Name.Entity',                 'ni'
    token 'Name.Exception',              'ne'
    token 'Name.Function',               'nf'
    token 'Name.Property',               'py'
    token 'Name.Label',                  'nl'
    token 'Name.Namespace',              'nn'
    token 'Name.Other',                  'nx'
    token 'Name.Tag',                    'nt'
    token 'Name.Variable',               'nv'
    token 'Name.Variable.Class',         'vc'
    token 'Name.Variable.Global',        'vg'
    token 'Name.Variable.Instance',      'vi'

    token 'Literal',                     'l'
    token 'Literal.Date',                'ld'

    token 'Literal.String',              's'
    token 'Literal.String.Backtick',     'sb'
    token 'Literal.String.Char',         'sc'
    token 'Literal.String.Doc',          'sd'
    token 'Literal.String.Double',       's2'
    token 'Literal.String.Escape',       'se'
    token 'Literal.String.Heredoc',      'sh'
    token 'Literal.String.Interpol',     'si'
    token 'Literal.String.Other',        'sx'
    token 'Literal.String.Regex',        'sr'
    token 'Literal.String.Single',       's1'
    token 'Literal.String.Symbol',       'ss'

    token 'Literal.Number',              'm'
    token 'Literal.Number.Float',        'mf'
    token 'Literal.Number.Hex',          'mh'
    token 'Literal.Number.Integer',      'mi'
    token 'Literal.Number.Integer.Long', 'il'
    token 'Literal.Number.Oct',          'mo'

    token 'Operator',                    'o'
    token 'Operator.Word',               'ow'

    token 'Punctuation',                 'p'

    token 'Comment',                     'c'
    token 'Comment.Multiline',           'cm'
    token 'Comment.Preproc',             'cp'
    token 'Comment.Single',              'c1'
    token 'Comment.Special',             'cs'

    token 'Generic',                     'g'
    token 'Generic.Deleted',             'gd'
    token 'Generic.Emph',                'ge'
    token 'Generic.Error',               'gr'
    token 'Generic.Heading',             'gh'
    token 'Generic.Inserted',            'gi'
    token 'Generic.Output',              'go'
    token 'Generic.Prompt',              'gp'
    token 'Generic.Strong',              'gs'
    token 'Generic.Subheading',          'gu'
    token 'Generic.Traceback',           'gt'

    token 'Generic.Lineno',              'gl'
  end
end
