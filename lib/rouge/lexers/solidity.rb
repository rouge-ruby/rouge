# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Solidity < RegexLexer
      title "Solidity"
      desc "Solidity, an Ethereum smart contract programming language"
      tag 'solidity'
      filenames '*.sol', '*.solidity'
      mimetypes 'text/x-solidity'

      # optional comment or whitespace
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z$_][\w$_]*/

      def self.detect?(text)
        return true if text.start_with? 'pragma solidity'
      end

      # TODO: seperate by "type"
      def self.keywords
        @keywords ||= Set.new %w(
          abstract anonymous as assembly break catch constant constructor continue
          contract do delete else emit enum event external fallback for function hex
          if indexed interface internal import is library mapping memory
          modifier new payable public pure pragma private return returns
          storage struct throw try type using var view while
        )
      end

      def self.builtins
        return @builtins if @builtins

        @builtins = Set.new %w(
          now
          false true
          balance now selector super this
          blockhash gasleft
          assert require revert
          selfdestruct suicide
          call callcode delegatecall
          send transfer
          addmod ecrecover keccak256 mulmod sha256 sha3 ripemd160
        )

        # TODO: use (currently shadowed by catch-all in :statements)
        abi = %w(encode encodePacked encodeWithSelector encodeWithSignature)
        @builtins.merge( abi.map { |i| "abi.#{i}" } )
        block = %w(coinbase difficulty gaslimit hash number timestamp)
        @builtins.merge( block.map { |i| "block.#{i}" } )
        msg = %w(data gas sender sig value)
        @builtins.merge( msg.map { |i| "msg.#{i}" } )
        tx = %w(gasprice origin)
        @builtins.merge( tx.map { |i| "tx.#{i}" } )
      end

      def self.constants
        @constants ||= Set.new %w(
          wei finney szabo ether
          seconds minutes hours days weeks years
        )
      end

      def self.keywords_type
        return @keywords_type if @keywords_type

        @keywords_type = Set.new %w(
          address bool byte bytes int string uint
        )

        # bytes1 .. bytes32
        @keywords_type.merge( (1..32).map { |i| "bytes#{i}" } )

        # size helper
        sizes = (8..256).step(8)
        # [u]int8 .. [u]int256
        @keywords_type.merge( sizes.map { |n|  "int#{n}" } )
        @keywords_type.merge( sizes.map { |n| "uint#{n}" } )
      end

      def self.reserved
        return @reserved if @reserved

        @reserved ||= Set.new %w(
          alias after apply auto case copyof default define final fixed
          immutable implements in inline let macro match mutable null of
          override partial promise receive reference relocatable sealed
          sizeof static supports switch typedef typeof ufixed unchecked
          virtual
        )

        # size helpers
        sizesm = (0..256).step(8)
        sizesn = (8..256).step(8)
        sizesmxn = sizesm.map { |m| m }
                     .product( sizesn.map { |n| n } )
                     .select { |m,n| m+n <= 256 }
        # [u]fixed{MxN}
        @reserved.merge(sizesmxn.map { |m,n|  "fixed#{m}x#{n}" })
        @reserved.merge(sizesmxn.map { |m,n| "ufixed#{m}x#{n}" })
      end

      start { push :bol }

      state :expr_bol do
        mixin :inline_whitespace

        rule(//) { pop! }
      end

      # :expr_bol is the same as :bol but without labels, since
      # labels can only appear at the beginning of a statement.
      state :bol do
        mixin :expr_bol
      end

      # TODO: natspec in comments
      state :inline_whitespace do
        rule %r/[ \t\r]+/, Text
        rule %r/\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule %r/\n+/m, Text, :bol
        rule %r(//(\\.|.)*?\n), Comment::Single, :bol
        mixin :inline_whitespace
      end

      state :expr_whitespace do
        rule %r/\n+/m, Text, :expr_bol
        mixin :whitespace
      end

      state :statements do
        mixin :whitespace
        rule %r/(hex)?\"/, Str, :string_double
        rule %r/(hex)?\'/, Str, :string_single
        rule %r('(\\.|\\[0-7]{1,3}|\\x[a-f0-9]{1,2}|[^\\'\n])')i, Str::Char
        rule %r/\d\d*\.\d+([eE]\d+)?/i, Num::Float
        rule %r/0x[0-9a-f]+/i, Num::Hex
        rule %r/\d+([eE]\d+)?/i, Num::Integer
        rule %r(\*/), Error
        rule %r([~!%^&*+=\|?:<>/-]), Operator
        rule %r/(?:block|msg|tx)\.[a-z]*\b/, Name::Builtin
        rule %r/[()\[\],.]/, Punctuation
        rule id do |m|
          name = m[0]

          if self.class.keywords.include? name
            token Keyword
          elsif self.class.builtins.include? name
            token Name::Builtin
          elsif self.class.constants.include? name
            token Keyword::Constant
          elsif self.class.keywords_type.include? name
            token Keyword::Type
          elsif self.class.reserved.include? name
            token Keyword::Reserved
          else
            token Name
          end
        end
      end

      state :root do
        mixin :expr_whitespace
        rule(//) { push :statement }
        # TODO: function declarations
      end

      state :statement do
        rule %r/;/, Punctuation, :pop!
        mixin :expr_whitespace
        mixin :statements
        rule %r/[{}]/, Punctuation
      end

      state :string_common do
        rule %r/\\(u[a-fA-F0-9]{4}|x..|[^x])/, Str::Escape
        rule %r/[^\\\"\'\n]+/, Str
        rule %r/\\\n/, Str # line continuation
        rule %r/\\/, Str # stray backslash
      end

      state :string_double do
        mixin :string_common
        rule %r/\"/, Str, :pop!
        rule %r/\'/, Str
      end

      state :string_single do
        mixin :string_common
        rule %r/\'/, Str, :pop!
        rule %r/\"/, Str
      end
    end
  end
end