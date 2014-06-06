module Rouge
  module Lexers
    class CSharp < RegexLexer
      tag 'swift'
      aliases 'apple_swift'
      filenames '*.swift'
      mimetypes 'text/x-swift' # TODO: this has to be revised

      desc 'Multi paradigm, compiled programming language developed by Apple for iOS and OS X development.' # From Wikipedia.

      # TODO: support more of unicode
      id = /@?[_a-z]\w*/i

      keywords = %w(
        class deinit enum extension func import init let protocol static struct subscript typealias var 
        
        break case continue default do else fallthrough if in for return switch where while
        
        as dynamicType is new super self Self Type __COLUMN__ __FILE__ __FUNCTION__ __LINE__
        
        associativity didSet get infix inout left mutating none nonmutating operator override postfix precedence prefix right set unowned unowned(safe) unowned(unsafe) weak willSet
      )

      keywords_type = %w(
        Int8 Int16 Int32 Int64 UInt8 UInt16 UInt32 UInt64
        Double Float
        Bool 
        String Character 
      )

      state :whitespace do
        rule /\s+/m, Text
        rule %r(//.*?\n), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :root do
        mixin :whitespace
        
        

        # rule /^\s*\[.*?\]/, Name::Attribute
#         rule /[$]\s*"/, Str, :splice_string
#         rule /[$]\s*<#/, Str, :splice_recstring
#         rule /<#/, Str, :recstring
# 
#         rule /(<\[)\s*(#{id}:)?/, Keyword
#         rule /\]>/, Keyword
# 
#         rule /[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
#         rule /@"(\\.|.)*?"/, Str
#         rule /"(\\.|.)*?["\n]/, Str
#         rule /'(\\.|.)'/, Str::Char
#         rule /0x[0-9a-f]+[lu]?/i, Num
#         rule %r(
#           [0-9]
#           ([.][0-9]*)? # decimal
#           (e[+-][0-9]+)? # exponent
#           [fldu]? # type
#         )ix, Num
         rule /\b(#{keywords.join('|')})\b/, Keyword
         rule /\b(#{keywords_type.join('|')})\b/, Keyword::Type
#         rule /class|struct|enum/, Keyword, :class
         rule /#{id}(?=\s*[(])/, Name::Function
         rule id, Name
      end

      state :class do
        mixin :whitespace
        rule id, Name::Class, :pop!
      end

      state :namespace do
        mixin :whitespace
        rule /(?=[(])/, Text, :pop!
        rule /(#{id}|[.])+/, Name::Namespace, :pop!
      end

    end
  end
end
