module Rouge
  module Lexers
    class Make < RegexLexer
      tag 'make'
      aliases 'makefile', 'mf', 'gnumake', 'bsdmake'
      filenames '*.make', 'Makefile', 'makefile', 'Makefile.*', 'GNUmakefile'
      mimetypes 'text/x-makefile'

      def self.analyze_text(text)
        return 0.2 if text =~ /^\.PHONY:/
      end

      bsd_special = %w(
        include undef error warning if else elif endif for endfor
      )

      gnu_special = %w(
        ifeq ifneq ifdef ifndef else endif include -include define endef :
      )

      line = /(?:\\.|\\\n|[^\\\n])*/m

      def initialize(opts={})
        super
        @shell = Shell.new(opts)
      end

      start { @shell.reset! }

      state :root do
        rule /^(?:[\t ]+.*\n|\n)+/ do
          delegate @shell
        end

        # rule /\$\((?:.*\\\n|.*\n)+/ do
        #   delegate Shell
        # end

        rule /\s+/, 'Text'

        rule /#.*?\n/, 'Comment'

        rule /(export)(\s+)(?=[a-zA-Z0-9_\${}\t -]+\n)/ do
          group 'Keyword'; group 'Text'
          push :export
        end

        rule /export\s+/, 'Keyword'

        # assignment
        rule /([a-zA-Z0-9_${}.-]+)(\s*)([!?:+]?=)/m do |m|
          token 'Name.Variable', m[1]
          token 'Text', m[2]
          token 'Operator', m[3]
          push :shell_line
        end

        rule /"(\\\\|\\.|[^"\\])*"/, 'Literal.String.Double'
        rule /'(\\\\|\\.|[^'\\])*'/, 'Literal.String.Single'
        rule /([^\n:]+)(:+)([ \t]*)/ do
          group 'Name.Label'; group 'Operator'; group 'Text'
          push :block_header
        end
      end

      state :export do
        rule /[\w\${}-]/, 'Name.Variable'
        rule /\n/, 'Text', :pop!
        rule /\s+/, 'Text'
      end

      state :block_header do
        rule /[^,\\\n#]+/, 'Name.Function'
        rule /,/, 'Punctuation'
        rule /#.*?/, 'Comment'
        rule /\\\n/, 'Text'
        rule /\\./, 'Text'
        rule /\n/ do
          token 'Text'
          pop!; push :block_body
        end
      end

      state :block_body do
        rule /(\t[\t ]*)([@-]?)/ do |m|
          group 'Text'; group 'Punctuation'
          push :shell_line
        end

        rule(//) { @shell.reset!; pop! }
      end

      state :shell do
        # macro interpolation
        rule /\$\(\s*[a-z_]\w*\s*\)/i, 'Name.Variable'
        rule(/.+?(?=\$\(|\)|\n)/m) { delegate @shell }
        rule(/\$\(|\)|\n/) { delegate @shell }
      end

      state :shell_line do
        rule /\n/, 'Text', :pop!
        mixin :shell
      end
    end
  end
end
