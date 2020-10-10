# Rouge Lexer for Unicon

module Rouge
  module Lexers
    class Unicon < RegexLexer
      title 'Unicon'
      desc 'Icon/Unicon'
      tag 'unicon'
      filenames '*.icn'
      mimetypes 'text/x-unicon'

      def self.keywords
        @keywords ||= Set.new %w(
abs acos any args asin atan bal callout center char chdir close collect copy cos cset delay delete detab display dtor entab errorclear exit exp find flush function get getch getche getenv iand icom image insert integer ior ishift ixor kbhit key left list loadfunc log many map match member move name numeric open ord pop pos proc pull push put read reads real remove rename repl reverse right rtod runerr save seek seq set sin sort sortf sqrt stop string system tab table tan trim type upto variable where write writes
&allocated &ascii &clock &collections &cset &current &date &dateline &digits &dump &e &error &errornumber &errortext &errorvalue &errout &fail &features &file &host &input &lcase &letters &level &line &main &null &output &phi &pi &pos &progname &random &regions &source &storage &subject &time &trace &ucase &version
abstract all break by case class create critical default do else end every fail global if import initial initially invocable link local method next not of package procedure record repeat return static suspend then thread to until while 
Abort Any Arb Arbno array Break Breakx chmod chown chroot classname cofail Color condvar constructor crypt ctime dbcolumns dbdriver dbkeys dblimits dbproduct dbtables display eventmask EvGet EvSend exec Fail fdup Fence fetch fieldnames filepair flock fork getegid geteuid getgid getgr gethost getpgrp getpid getppid getpw getrusage getserv gettimeofday getuid globalnames gtime ioctl istate keyword kill Len link load localnames lock max membernames methodnames methods min mkdir mutex name NotAny Nspan opencl oprec paranames parent pipe Pos proc readlink ready receive Rem rmdir Rpos Rtab select send setenv setgid setgrent sethostent setpgrp setpwent setservent setuid signal Span spawn sql stat staticnames structure Succeed symlink sys_errstr syswrite Tab trap truncate trylock umask unlock utime wait
        )
      end

      def self.operators
        @operators ||= Set.new %w(! : / \ - + = * . ? | ~ ^ % ** ++ -- $ ~= < <= > >= == ~== << <<= >> >>= === ~=== := :=: <- <-> ?? @ @> @>> <@ <<@ || ||| & .| -> => .> [: :] ; [ ] { })
      end

      state :root do
        rule /\s*#.*$/, Comment
          rule /\s+/m, Text::Whitespace
        rule /"/, Str::Double, :string

        decimal = %r/[\d]+/
        rule %r/#{decimal}(\.#{decimal})(e[+-]?#{decimal})?/, Num::Float
        rule %r/\.#{decimal}(e[+-]?#{decimal})?/, Num::Float
        rule %r/#{decimal}(e[+-]?#{decimal})?/, Num::Integer

        rule /\w+/ do |m|
          if self.class.keywords.include?(m[0])
            token Keyword
          elsif
            token Name
          end
        end
        
        rule /[\(\)=~:<!:\\+\-\*\/,\/=\.\?|~^%$<>@&;\[\]\{\}]+/ do |m|
          if self.class.operators.include?(m[0])
            token Operator
          else
            token Punctuation
          end
        end

      end

      state :string do
        rule /[^\\"]+/, Str::Double 
        rule /\\./, Str::Escape 
        rule /"/, Str::Double, :pop!
      end
    end
  end
end
