module Rouge
  module Lexers
    # A lexer for the Haml templating system for Ruby.
    # @see http://haml.info
    class Haml < RegexLexer
      include Indentation

      desc "The Haml templating system for Ruby (haml.info)"

      tag 'haml'
      aliases 'HAML'

      filenames '*.haml'
      mimetypes 'text/x-haml'

      def self.analyze_text(text)
        return 0.1 if text.start_with? '!!!'
      end

      # @option opts :filters
      #   A hash of filter name to lexer of how various filters should be
      #   highlighted.  By default, :javascript, :css, :ruby, and :erb
      #   are supported.
      def initialize(opts={})
        (opts.delete(:filters) || {}).each do |name, lexer|
          unless lexer.respond_to? :lex
            lexer = Lexer.find(lexer) or raise "unknown lexer: #{lexer}"
            lexer = lexer.new(options)
          end

          self.filters[name.to_s] = lexer
        end

        super(opts)
      end

      def ruby
        @ruby ||= Ruby.new(options)
      end

      def html
        @html ||= HTML.new(options)
      end

      def filters
        @filters ||= {
          'javascript' => Javascript.new(options),
          'css' => CSS.new(options),
          'ruby' => ruby,
          'erb' => ERB.new(options),
          'markdown' => Markdown.new(options),
          # TODO
          # 'sass' => Sass.new(options),
          # 'textile' => Textile.new(options),
          # 'maruku' => Maruku.new(options),
        }
      end

      start { ruby.reset!; html.reset! }

      identifier = /[\w:-]+/
      ruby_var = /[a-z]\w*/

      # Haml can include " |\n" anywhere,
      # which is ignored and used to wrap long lines.
      # To accomodate this, use this custom faux dot instead.
      dot = /[ ]\|\n(?=.*[ ]\|)|./

      # In certain places, a comma at the end of the line
      # allows line wrapping as well.
      comma_dot = /,\s*\n|#{dot}/

      state :root do
        rule /\s*\n/, 'Text'
        rule(/\s*/) { |m| token 'Text'; indentation(m[0]) }
      end

      state :content do
        mixin :css
        rule(/%#{identifier}/) { token 'Name.Tag'; pop!; push :tag }
        rule /!!!#{dot}*\n/, 'Name.Namespace', :pop!
        rule %r(
          (/) (\[#{dot}*?\]) (#{dot}*\n)
        )x do
          group 'Comment'; group 'Comment.Special'; group 'Comment'
          pop!
        end

        rule %r(/#{dot}*\n) do
          token 'Comment'
          pop!
          starts_block :html_comment_block
        end

        rule /-##{dot}*\n/ do
          token 'Comment'
          pop!
          starts_block :haml_comment_block
        end

        rule /-/ do
          token 'Punctuation'
          reset_stack
          push :ruby_line
        end

        # filters
        rule /:(#{dot}*)\n/ do |m|
          token 'Name.Decorator'
          pop!
          starts_block :filter_block

          filter_name = m[1].strip

          @filter_lexer = self.filters[filter_name]
          @filter_lexer.reset! unless @filter_lexer.nil?

          debug { "    haml: filter #{filter_name.inspect} #{@filter_lexer.inspect}" }
        end

        mixin :eval_or_plain
      end

      state :css do
        rule(/\.#{identifier}/) { token 'Name.Class'; pop!; push :tag }
        rule(/##{identifier}/) { token 'Name.Function'; pop!; push :tag }
      end

      state :tag do
        mixin :css
        rule(/\{#{comma_dot}*?\}/) { delegate ruby }
        rule(/\[#{dot}*?\]/) { delegate ruby }
        rule /\(/, 'Punctuation', :html_attributes
        rule /\s*\n/, 'Text', :pop!

        # whitespace chompers
        rule /[<>]{1,2}(?=[ \t=])/, 'Punctuation'

        mixin :eval_or_plain
      end

      state :plain do
        rule(/([^#\n]|#[^{\n]|(\\\\)*\\#\{)+/) { delegate html }
        mixin :interpolation
        rule(/\n/) { token 'Text'; reset_stack }
      end

      state :eval_or_plain do
        rule /[&!]?==/, 'Punctuation', :plain
        rule /[&!]?[=!]/ do
          token 'Punctuation'
          reset_stack
          push :ruby_line
        end

        rule(//) { push :plain }
      end

      state :ruby_line do
        rule /\n/, 'Text', :pop!
        rule(/,[ \t]*\n/) { delegate ruby }
        rule /[ ]\|[ \t]*\n/, 'Literal.String.Escape'
        rule(/.*?(?=(,$| \|)?[ \t]*$)/) { delegate ruby }
      end

      state :html_attributes do
        rule /\s+/, 'Text'
        rule /#{identifier}\s*=/, 'Name.Attribute', :html_attribute_value
        rule identifier, 'Name.Attribute'
        rule /\)/, 'Text', :pop!
      end

      state :html_attribute_value do
        rule /\s+/, 'Text'
        rule ruby_var, 'Name.Variable', :pop!
        rule /@#{ruby_var}/, 'Name.Variable.Instance', :pop!
        rule /\$#{ruby_var}/, 'Name.Variable.Global', :pop!
        rule /'(\\\\|\\'|[^'\n])*'/, 'Literal.String', :pop!
        rule /"(\\\\|\\"|[^"\n])*"/, 'Literal.String', :pop!
      end

      state :html_comment_block do
        rule /#{dot}+/, 'Comment'
        mixin :indented_block
      end

      state :haml_comment_block do
        rule /#{dot}+/, 'Comment.Preproc'
        mixin :indented_block
      end

      state :filter_block do
        rule /([^#\n]|#[^{\n]|(\\\\)*\\#\{)+/ do
          if @filter_lexer
            delegate @filter_lexer
          else
            token 'Name.Decorator'
          end
        end

        mixin :interpolation
        mixin :indented_block
      end

      state :interpolation do
        rule /(#\{)(#{dot}*?)(\})/ do |m|
          token 'Literal.String.Interpol', m[1]
          delegate ruby, m[2]
          token 'Literal.String.Interpol', m[3]
        end
      end

      state :indented_block do
        rule(/\n/) { token 'Text'; reset_stack }
      end
    end
  end
end
