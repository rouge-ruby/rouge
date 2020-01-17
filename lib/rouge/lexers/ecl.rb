# -*- codding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class ECL < RegexLexer
      tag 'ecl'
      filenames '*.ecl'
      mimetypes 'application/x-ecl'

      title "ECL"
      desc "Enterprise Control Language"
      
      ws = %r((?:\s|//.*?\n|/[*].*?[*]/)+)
      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      template = %w(
        append apply break constant debug declare demangle else elseif
        end endregion error expand export exportxml for forall getdatatype if
        ifdefined inmodule isdefined isvalid line link loop mangle onwarning option
        region set stored text trace uniquename warning webservice workunit loadxml
      )

      typed = %w(
        data string qstring varstring varunicode unicode utf8
      )

      type = %w(
        ascii big_endian boolean data decimal ebcdic grouped integer
        linkcounted pattern qstring real record rule set of streamed
        string token udecimal unicode utf8 unsigned varstring varunicode
      )

      keywords = %w(
        and or in not all any as from 
        atmost before beginc best between case const counter 
        csv descend embed encrypt end endc endembed endmacro 
        enum except exclusive expire export extend fail few 
        first flat full function functionmacro group heading hole 
        ifblock import joined keep keyed last left limit 
        load local locale lookup macro many maxcount maxlength 
        _token module interface named nocase noroot noscan nosort 
        of only opt outer overwrite packed partition penalty 
        physicallength pipe quote record repeat return right rows 
        scan self separator service shared skew skip sql 
        store terminator thor threshold token transform trim type 
        unicodeorder unsorted validate virtual whole wild within xml 
        xpath after cluster compressed compression default encoding escape 
        fileposition forward grouped inner internal linkcounted literal lzw 
        mofn multiple namespace wnotrim noxpath onfail prefetch retry 
        rowset scope smart soapaction stable timelimit timeout unordered 
        unstable update use width
      )

      functions = %w(
        abs acos aggregate allnodes apply ascii asin asstring 
        atan _token ave case catch choose choosen choosesets 
        clustersize combine correlation cos cosh count covariance cron 
        dataset dedup define denormalize dictionary distribute distributed distribution 
        ebcdic enth error evaluate event eventextra eventname exists 
        exp failcode failmessage fetch fromunicode fromxml getenv getisvalid 
        global graph group hash hashcrc having httpcall httpheader 
        if iff index intformat isvalid iterate join keyunicode 
        length library limit ln local log loop map 
        matched matchlength matchposition matchtext matchunicode max merge mergejoin 
        min nofold nolocal nonempty normalize parse pipe power 
        preload process project pull random range rank ranked 
        realformat recordof regexfind regexreplace regroup rejected rollup round 
        roundup row rowdiff sample set sin sinh sizeof 
        soapcall sort sorted sqrt stepped stored sum table 
        tan tanh thisnode topn tounicode toxml transfer transform 
        trim truncate typeof ungroup unicodeorder variance which workunit 
        xmldecode xmlencode xmltext xmlunicode apply assert build buildindex 
        evaluate fail keydiff keypatch loadxml nothor notify output 
        parallel sequential soapcall wait
      )

      class1 = %w(
        file date str math metaphone metaphone3 uni audit blas system
      )

      class2 = %w(
        debug email job log thorlib util workunit
      )

      state :string_character_escape do
        rule %r/\\\\(x\\h{2}|[0-2][0-7]{,2}|3[0-6][0-7]?|37[0-7]?|[4-7][0-7]?|.|$)/, Text
      end

      state :single_quote do
        rule %r([xDQUV]?'([^'\\]*(?:\\.[^'\\]*)*)'), Str::Single
        mixin :string_character_escape
      end

      state :inline_whitespace do
        rule %r/[ \t\r]+/, Text
        rule %r/\\\n/, Text # line continuation
        rule %r(/(\\\n)?[*].*?[*](\\\n)?/)m, Comment::Multiline
      end

      state :whitespace do
        rule %r/\n+/m, Text
        rule %r(//.*?$), Comment::Single
        mixin :inline_whitespace
      end

      state :root do
	mixin :whitespace
	mixin :single_quote

        rule %r(\b(?i:(#{functions.join('|')}))\s*(\()), Name::Function
        rule %r(\b(?i:(#{keywords.join('|')}))\b), Keyword
        rule %r(#(?i:(#{template.join('|')}))\b), Keyword::Declaration
        rule %r(\b(?i:(std)\.(#{class1.join('|')})\.(#{class2.join('|')}))\b), Name::Class

        rule %r(\b(?i:(#{typed.join('|')}))\d+\b), Keyword::Type
        rule %r(\b(?i:(#{type.join('|')}))\b), Keyword::Type
        rule %r(\b(?i:(integer|unsigned))[1-8]\b), Keyword::Type
        rule %r(\b(?i:real)(4|8)\b), Keyword::Type
        rule %r(\b(?i:(u)?decimal)(\d+(_\d+)?)\b), Keyword::Type

        rule %r(\b(?i:(and|not|or|in))\b), Operator::Word
        rule %r([:=||>|<|<>|/|\\|+|-|=]), Operator 

        rule %r(\d+\.\d+(e[\+\-]?\d+)?), Num::Float
        rule %r(x[0-9a-fA-F]+), Num::Hex

        rule %r(0[xX][0-9a-fA-F]+), Num::Hex
        rule %r(0[0-9a-fA-F]+[xX]), Num::Hex
        rule %r(0[bB][01]+), Num::Bin
        rule %r([01]+[bB]), Num::Bin
        rule %r(\d+), Num::Integer
        rule %r(\b(?i:(false|true))\b), Name

        rule %r([\[\]{}();,]), Punctuation
	rule %r(#{id}), Name
      end
    end
  end
end
