# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Perl < RegexLexer
      title "Perl"
      desc "The Perl scripting language (perl.org)"

      tag 'perl'
      aliases 'pl'

      filenames '*.pl', '*.pm', '*.t'
      mimetypes 'text/x-perl', 'application/x-perl'

      def self.detect?(text)
        return true if text.shebang? 'perl'
      end

      KEYWORDS = Set.new %w(
        case continue do else elsif for foreach if last my next our
        redo reset then unless until while use print new BEGIN CHECK
        INIT END return
      )

      BUILTINS = Set.new %w(
        abs accept alarm atan2 bind binmode bless caller chdir chmod
        chomp chop chown chr chroot close closedir connect continue cos
        crypt dbmclose dbmopen defined delete die dump each endgrent
        endhostent endnetent endprotoent endpwent endservent eof eval
        exec exists exit exp fcntl fileno flock fork format formline getc
        getgrent getgrgid getgrnam gethostbyaddr gethostbyname gethostent
        getlogin getnetbyaddr getnetbyname getnetent getpeername
        getpgrp getppid getpriority getprotobyname getprotobynumber
        getprotoent getpwent getpwnam getpwuid getservbyname getservbyport
        getservent getsockname getsockopt glob gmtime goto grep hex
        import index int ioctl join keys kill last lc lcfirst length
        link listen local localtime log lstat map mkdir msgctl msgget
        msgrcv msgsnd my next no oct open opendir ord our pack package
        pipe pop pos printf prototype push quotemeta rand read readdir
        readline readlink readpipe recv redo ref rename require reverse
        rewinddir rindex rmdir scalar seek seekdir select semctl semget
        semop send setgrent sethostent setnetent setpgrp setpriority
        setprotoent setpwent setservent setsockopt shift shmctl shmget
        shmread shmwrite shutdown sin sleep socket socketpair sort splice
        split sprintf sqrt srand stat study substr symlink syscall sysopen
        sysread sysseek system syswrite tell telldir tie tied time times
        tr truncate uc ucfirst umask undef unlink unpack unshift untie
        utime values vec wait waitpid wantarray warn write
      )

      OPERATOR_WORDS = Set.new %w(eq lt gt le ge ne not and or cmp)

      re_tok = Str::Regex

      state :balanced_regex do
        rule %r/\s+/, Text
        rule %r/./ do |m|
          pop!
          open_regex!(m[0])
          token Str::Delimiter
        end
      end

      state :continued_regex do
        mixin :regex
      end

      state :regex_flags do
        rule %r/[msixpodualngcr]+/, Str::Affix
        rule(//) { pop! }
      end

      state :regex do
        rule %r/./ do |m|
          if m[0] == @regex_end
            token Str::Delimiter
            goto :regex_flags
          else
            fallthrough!
          end
        end

        rule %r/\\[0-7][0-7][0-7]/, Str::Escape
        rule %r/\\.(?:[{]\w+[}])?/, Str::Escape
        rule %r/[{]\d+(?:,\d+)?[}]/, Operator
        rule %r/\[\^?/, Punctuation, :regex_char_class
        rule %r/[?]|[.]|[|]|[*+][?]?/, Operator
        rule %r/[(](?:[?][=!<:]?)?/, Punctuation
        rule %r/[(][?]<!/, Punctuation
        rule %r/[{})]/, Punctuation
        rule %r/./, Str::Regex
      end

      state :regex_char_class do
        rule(/\^/) { token Punctuation; goto :regex_char_class_inner }
        rule(/-/) { token Str::Regex; goto :regex_char_class_inner }
        rule(//) { goto :regex_char_class_inner }
      end

      state :regex_char_class_inner do
        rule %r/-(?!\])/, Punctuation
        rule %r/\\./, Str::Escape
        rule %r/[^-\]\\]+/, Str::Regex
        rule %r/\]/, Punctuation, :pop!
      end

      BALANCED_DELIMITERS = {
        '{' => '}',
        '(' => ')',
        '[' => ']',
        '<' => '>',
      }

      def open_regex!(delimiter)
        @regex_end = BALANCED_DELIMITERS.fetch(delimiter, delimiter)
        push :regex
      end

      def open_regex_operator!(delimiter)
        if BALANCED_DELIMITERS.key?(delimiter)
          push :balanced_regex
        else
          push :continued_regex
        end

        open_regex!(delimiter)
      end

      state :expr_start do
        mixin :whitespace
        rule %r(/) do
          open_regex!('/')
          token Str::Delimiter
        end

        rule(//) { pop! }
      end

      state :whitespace do
        rule %r/#.*/, Comment::Single
        rule %r/\s+/, Text
        rule %r/^=[a-zA-Z0-9]+\s+.*?\n=cut/m, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule %r/(format)(\s+)([a-zA-Z0-9_]+)(\s*)(=)(\s*\n)/ do
          groups Keyword, Text, Name, Text, Punctuation, Text

          push :format
        end

        rule %r/\w+/ do |m|
          w = m[0]
          if KEYWORDS.include?(w)
            token Keyword
          elsif OPERATOR_WORDS.include?(w)
            token Operator::Word
          else
            fallthrough!
          end
        end

        # # matches: common case, m-optional
        # rule %r(m?/(\\\\|\\/|[^/\n])*/[msixpodualngc]*), re_tok
        # rule %r(m(?=[/!\\{<\[\(@%\$])), re_tok, :balanced_regex

        # arbitrary non-whitespace delimiters
        # rule %r(m\s*([^\w\s])((\\\\|\\\1)|[^\1])*?\1[msixpodualngc]*)m, re_tok
        # rule %r(m\s+(\w)((\\\\|\\\1)|[^\1])*?\1[msixpodualngc]*)m, re_tok

        rule %r/\s+/, Text

        rule(/(?=[a-z_]\w*(\s*#.*\n)*\s*=>)/i) { push :fat_comma }

        rule %r/(s|tr|y)(\s*)([^\w\s])/ do |m|
          open_regex_operator!(m[3])
          groups Str::Affix, Text, Str::Delimiter
        end

        rule %r/(s|tr|y)(\s+)(\S)/ do |m|
          open_regex_operator!(m[3])
          groups Str::Affix, Text, Str::Delimiter
        end

        rule %r/(m)(\s*)(\S)/ do |m|
          open_regex!(m[3])
          groups Str::Affix, Text, Str::Delimiter
        end

        rule %r/\w+/ do |m|
          w = m[0]
          if BUILTINS.include?(w)
            token Name::Builtin
          else
            fallthrough!
          end
        end

        rule %r/((__(DIE|WARN)__)|(DATA|STD(IN|OUT|ERR)))\b/,
          Name::Builtin::Pseudo

        rule %r/<<([\'"]?)([a-zA-Z_][a-zA-Z0-9_]*)\1;?\n.*?\n\2\n/m, Str

        rule %r/(__(END|DATA)__)\b/, Comment::Preproc, :end_part
        rule %r/\$\^[ADEFHILMOPSTWX]/, Name::Variable::Global
        rule %r/\$[\\"'\[\]&`+*.,;=%~?@$!<>(^\|\/_-](?!\w)/, Name::Variable::Global
        rule %r/[$@%&*][$@%&*#_]*(?=[a-z{\[;])/i, Name::Variable, :varname

        rule %r/\[\]|\*\*|::|<<|>>|>=|<=|<=>|={3}|!=|=~|!~|&&?|\|\||\.{1,3}/,
          Operator, :expr_start
        rule %r/[-+\/*%=<>&^\|!\\~]=?/, Operator, :expr_start

        rule %r/0_?[0-7]+(_[0-7]+)*/, Num::Oct
        rule %r/0x[0-9A-Fa-f]+(_[0-9A-Fa-f]+)*/, Num::Hex
        rule %r/0b[01]+(_[01]+)*/, Num::Bin
        rule %r/(\d*(_\d*)*\.\d+(_\d*)*|\d+(_\d*)*\.\d+(_\d*)*)(e[+-]?\d+)?/i,
          Num::Float
        rule %r/\d+(_\d*)*e[+-]?\d+(_\d*)*/i, Num::Float
        rule %r/\d+(_\d+)*/, Num::Integer

        rule %r/'/, Punctuation, :sq
        rule %r/"/, Punctuation, :dq
        rule %r/`/, Punctuation, :bq
        rule %r/<([^\s>]+)>/, re_tok
        rule %r/(q|qq|qw|qr|qx)\{/, Str::Other, :cb_string
        rule %r/(q|qq|qw|qr|qx)\(/, Str::Other, :rb_string
        rule %r/(q|qq|qw|qr|qx)\[/, Str::Other, :sb_string
        rule %r/(q|qq|qw|qr|qx)</, Str::Other, :lt_string
        rule %r/(q|qq|qw|qr|qx)(\W)(.|\n)*?\2/, Str::Other

        rule %r/package\b/, Keyword, :modulename
        rule %r/sub\b/, Keyword, :funcname
        rule %r/[(]/, Punctuation, :expr_start
        rule %r/[)\[\]:;,<>\/?{}]/, Punctuation

        rule(/(?=\w)/) { push :name }
      end

      state :format do
        rule %r/\.\n/, Str::Interpol, :pop!
        rule %r/.*?\n/, Str::Interpol
      end

      state :fat_comma do
        rule %r/#.*/, Comment::Single
        rule %r/\w+/, Str
        rule %r/\s+/, Text
        rule %r/=>/, Operator, :pop!
      end

      state :name_common do
        rule %r/\w+::/, Name::Namespace
        rule %r/[\w:]+/, Name::Variable, :pop!
      end

      state :varname do
        rule %r/\s+/, Text
        rule %r/[{\[]/, Punctuation, :pop! # hash syntax
        rule %r/[),]/, Punctuation, :pop! # arg specifier
        rule %r/[;]/, Punctuation, :pop! # postfix
        mixin :name_common
      end

      state :name do
        mixin :name_common
        rule %r/[A-Z_]+(?=[^a-zA-Z0-9_])/, Name::Constant, :pop!
        rule(/(?=\W)/) { pop! }
      end

      state :modulename do
        rule %r/[a-z_]\w*/i, Name::Namespace, :pop!
      end

      state :funcname do
        rule %r/[a-zA-Z_]\w*[!?]?/, Name::Function
        rule %r/\s+/, Text

        # argument declaration
        rule %r/(\([$@%]*\))(\s*)/ do
          groups Punctuation, Text
        end

        rule %r/.*?{/, Punctuation, :pop!
        rule %r/;/, Punctuation, :pop!
      end

      state :sq do
        rule %r/\\[\\']/, Str::Escape
        rule %r/[^\\']+/, Str::Single
        rule %r/'/, Punctuation, :pop!
        rule %r/\\/, Str::Single
      end

      state :dq do
        mixin :string_intp
        rule %r/\\[\\tnrabefluLUE"$@]/, Str::Escape
        rule %r/\\0\d{2}/, Str::Escape
        rule %r/\\o\{\d+\}/, Str::Escape
        rule %r/\\x\h{2}/, Str::Escape
        rule %r/\\x\{\h+\}/, Str::Escape
        rule %r/\\c./, Str::Escape
        rule %r/\\N\{[^\}]+\}/, Str::Escape
        rule %r/[^\\"]+?/, Str::Double
        rule %r/"/, Punctuation, :pop!
        rule %r/\\/, Str::Escape
      end

      state :bq do
        mixin :string_intp
        rule %r/\\[\\tnr`]/, Str::Escape
        rule %r/[^\\`]+?/, Str::Backtick
        rule %r/`/, Punctuation, :pop!
      end

      [[:cb, '\{', '\}'],
       [:rb, '\(', '\)'],
       [:sb, '\[', '\]'],
       [:lt, '<',  '>']].each do |name, open, close|
        tok = Str::Other
        state :"#{name}_string" do
          rule %r/\\[#{open}#{close}\\]/, tok
          rule %r/\\/, tok
          rule(/#{open}/) { token tok; push }
          rule %r/#{close}/, tok, :pop!
          rule %r/[^#{open}#{close}\\]+/, tok
        end
      end

      state :in_interp do
        rule %r/}/, Str::Interpol, :pop!
        rule %r/\s+/, Text
        rule %r/[a-z_]\w*/i, Str::Interpol
      end

      state :string_intp do
        rule %r/[$@][{]/, Str::Interpol, :in_interp
        rule %r/[$@][a-z_]\w*/i, Str::Interpol
      end

      state :end_part do
        # eat the rest of the stream
        rule %r/.+/m, Comment::Preproc, :pop!
      end
    end
  end
end
