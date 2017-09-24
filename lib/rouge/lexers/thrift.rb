module Rouge
  module Lexers
    class Thrift < RegexLexer
      desc 'Apache Thrift (https://thrift.apache.org/)'
      tag 'thrift'
      filenames '*.thrift'

      mimetypes 'text/x-thrift', 'application/x-thrift'

      def self.declarations
        @declarations ||= Set.new %w(
          namespace const enum typedef struct
          php_namespace xsd_namespace
        )
      end

      def self.keywords
        @keywords ||= Set.new %w(
          smalltalk.category smalltalk.prefix

          const typedef enum senum struct xsd_all
          union exception service extends
        )
      end

      def self.keywords_type
        @keywords_type ||= Set.new %w(
          cpp java py perl rb cocoa csharp

          required optional xsd_optional xsd_nillable xsd_attrs
          python.immutable

        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          bool byte i8 i16 i32 i64 double string binary slist map set
          list cpp_type
        )
      end

      # Literal
      # [37] Literal         ::=  ('"' [^"]* '"') | ("'" [^']* "'")
      #
      # Identifier
      # [38] Identifier      ::=  ( Letter | '_' ) ( Letter | Digit | '.' | '_' )*
      # [39] STIdentifier    ::=  ( Letter | '_' ) ( Letter | Digit | '.' | '_' | '-' )*
      #
      # List Separator
      # [40] ListSeparator   ::=  ',' | ';'
      #
      # Letters and Digits
      # [41] Letter          ::=  ['A'-'Z'] | ['a'-'z']
      # [42] Digit           ::=  ['0'-'9']





      # [32] ConstValue      ::=  IntConstant | DoubleConstant | Literal | Identifier | ConstList | ConstMap
      #
      # [33] IntConstant     ::=  ('+' | '-')? Digit+
      #
      # [34] DoubleConstant  ::=  ('+' | '-')? Digit* ('.' Digit+)? ( ('E' | 'e') IntConstant )?
      #
      # [35] ConstList       ::=  '[' (ConstValue ListSeparator?)* ']'
      #
      # [36] ConstMap        ::=  '{' (ConstValue ':' ConstValue ListSeparator?)* '}'
      #
      name = /[a-z_][a-z0-9_.]*/i

      state :comment do
        rule /[^*]+/, Comment
        rule %r([*]/), Comment, :pop!
        rule /[*]+/, Comment
      end

      state :comments_and_whitespace do
        rule %r(/[*]), Comment, :comment
        rule %r(//.*$), Comment
        rule /\s+/, Text
      end

      state :root do
        mixin :comments_and_whitespace

        rule name do |m|
          if self.class.keywords.include?(m[0])
            token Keyword
          elsif self.class.keywords_type.include?(m[0])
            token Keyword::Type
          elsif self.class.declarations.include?(m[0])
            token Keyword::Declaration
          elsif self.class.builtins.include?(m[0])
            token Name::Builtin
          else
            token Name
          end
        end

        rule /[()\[\]{};:=,<>*]/, Punctuation
        rule /'.*?'/, Str
        rule /".*?"/, Str
        rule /[+-]?\d+/, Num::Integer
      end
    end
  end
end

