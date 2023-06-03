# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SPL < RegexLexer
      title "SPL"
      desc "Splunk Query Language"
      tag 'spl'
      aliases 'splunk'
      filenames '*.spl'

      # Greatly inspired by https://github.com/ChrisYounger/highlighter/blob/master/appserver/static/spl_language.js
      
      # Serves both as the list of all available commands and their list of allowed arguments, if any
      def self.command_arguments
        @command_arguments = {
          "abstract" => ['maxterms','maxlines'],
          "accum" => [''],
          "addcoltotals" => ['labelfield','label'],
          "addinfo" => [''],
          "addtotals" => ['row','col','labelfield','label','fieldname'],
          "analyzefields" => ['classfield'],
          "anomalies" => ['threshold','labelonly','normalize','maxvalues','field','blacklist','blacklistthreshold'],
          "anomalousvalue" => ['minsupcount','maxanofreq','minsupfreq','minnormfreq','pthresh','action'],
          "anomalydetection" => ['pthresh','cutoff','method','action','action'],
          "append" => ['extendtimerange','maxtime','maxout','timeout'],
          "appendcols" => ['override','extendtimerange','maxtime','maxout','timeout'],
          "appendpipe" => ['run_in_preview'],
          "archivebuckets" => ['forcerun','retries'],
          "arules" => ['sup','conf'],
          "associate" => ['supcnt','supfreq','improv'],
          "audit" => [''],
          "autoregress" => ['p'],
          "bin" => ['bins','minspan'],
          "bucketdir" => ['maxcount','countfield','sep','pathfield','sizefield'],
          "chart" => ['sep','format','cont','limit','minspan','minspan','useother','useother','aligntime','span','start','end','nullstr','otherstr','bins'],
          "cluster" => ['t','delims','showcount','countfield','labelfield','field','labelonly','match'],
          "cofilter" => [''],
          "collect" => ['addtime','index','index','file','spool','marker','testmode','run_in_preview','host','source','sourcetype'],
          "concurrency" => ['start','output','duration'],
          "contingency" => ['usetotal','totalstr','maxrows','maxcols','mincolcover','minrowcover'],
          "convert" => ['timeformat'],
          "correlate" => [''],
          "datamodel" => [''],
          "dbinspect" => ['index','corruptonly','span'],
          "dedup" => ['keepevents','keepempty','consecutive'],
          "delete" => [''],
          "delta" => ['p'],
          "diff" => ['position1','position2','attribute','diffheader','context','maxlen'],
          "erex" => ['fromfield','maxtrainers','examples','counterexamples'],
          "eval" => ['field'],
          "eventcount" => ['index','summarize','report_size','list_vix'],
          "eventstats" => ['allnum'],
          "extract" => ['segment','reload','kvdelim','pairdelim','limit','maxchars','mv_add','clean_keys'],
          "fieldformat" => [''],
          "fields" => [''],
          "fieldsummary" => ['maxvals'],
          "file" => [''],
          "filldown" => [''],
          "fillnull" => ['value'],
          "findtypes" => ['max'],
          "foreach" => ['fieldstr','matchstr','matchseg1','matchseg2','matchseg3'],
          "format" => ['maxresults','mvsep'],
          "from" => [''],
          "gauge" => [''],
          "gentimes" => ['increment','start','end'],
          "geom" => ['gen'],
          "geomfilter" => [''],
          "geostats" => ['translatetoxy','latfield','longfield','outputlatfield','outputlongfield','globallimit','locallimit','binspanlat','maxzoomlevel','binspanlong'],
          "head" => ['limit','null','keeplast'],
          "highlight" => [''],
          "history" => ['events'],
          "iconify" => [''],
          "input" => ['sourcetype','index','add','remove'],
          "inputcsv" => ['dispatch','append','start','max','events'],
          "inputlookup" => ['append','start','max'],
          "iplocation" => ['prefix','allfields','lang'],
          "join" => ['left','right','usetime','earlier','overwrite','max','type','field'],
          "kmeans" => ['reps','maxiters','t','k','cfield','showcentroid','dt'],
          "kvform" => ['form','field'],
          "loadjob" => ['events','job_delegate','artifact_offset','ignore_running','savedsearch'],
          "localize" => ['maxpause','timeafter','timebefore'],
          "localop" => [''],
          "lookup" => ['local','update','event_time_field'],
          "makecontinuous" => ['bins','minspan','span','start','end','aligntime'],
          "makejson" => ['output'],
          "makemv" => ['delim','allowempty','setsv','tokenizer'],
          "makeresults" => ['count','annotate','splunk_server','splunk_server_group'],
          "map" => ['maxsearches','search'],
          "mcollect" => ['index','file','split','spool','prefix_field','host','source','sourcetype'],
          "metadata" => ['index','splunk_server','splunk_server_group','datatype','type'],
          "metasearch" => ['savedsearch','savedsplunk','field','eventtypetag','hosttag'],
          "meventcollect" => ['index','split','spool','prefix_field','host','source','sourcetype'],
          "mstats" => ['prestats','append','backfill','update_period','span','savedsearch','savedsplunk','field'],
          "multikv" => ['conf','copyattrs','forceheader','multitable','noheader','rmorig','fields','filter'],
          "multisearch" => [''],
          "mvcombine" => ['delim'],
          "mvexpand" => ['limit'],
          "nomv" => [''],
          "outlier" => ['param','uselower','mark','action'],
          "outputcsv" => ['append','create_empty','override_if_empty','dispatch','usexml','singlefile'],
          "outputlookup" => ['append','create_empty','override_if_empty','max','key_field','createinapp','output_format'],
          "outputtelemetry" => ['input','type','component','support','anonymous','license','optinrequired'],
          "outputtext" => ['usexml'],
          "overlap" => [''],
          "pivot" => [''],
          "predict" => ['correlate','future_timespan','holdback','period','suppress','algorithm','upper','lower'],
          "rangemap" => ['default','field'],
          "rare" => ['showcount','showperc','limit','countfield','percentfield','useother','otherstr'],
          "redistribute" => ['num_of_reducers'],
          "regex" => [''],
          "relevancy" => [''],
          "reltime" => [''],
          "rename" => [''],
          "replace" => [''],
          "rest" => ['count','splunk_server','splunk_server_group','timeout'],
          "return" => [''],
          "reverse" => [''],
          "rex" => ['field','max_match','offset_field','mode'],
          "rtorder" => ['discard','buffer_span','max_buffer_size'],
          "savedsearch" => ['nosubstitution'],
          "script" => ['maxinputs'],
          "scrub" => ['dictionary','timeconfig','namespace','public-terms','private-terms','name-terms'],
          "search" => ['index','sourcetype','source','eventtype','tag','host','earliest','latest','_index_earliest','_index_latest','savedsearch','savedsplunk','field'],
          "searchtxn" => ['max_terms','use_disjunct','eventsonly'],
          "selfjoin" => ['overwrite','max','keepsingle'],
          "sendemail" => ['to','from','cc','bcc','paperorientation','priority','papersize','content_type','format','subject','message','footer','sendresults','inline','sendcsv','sendpdf','pdfview','server','graceful','width_sort_columns','use_ssl','use_tls','maxinputs','maxtime'],
          "set" => [''],
          "shape" => ['maxvalues','maxresolution'],
          "sichart" => ['sep','format','cont','limit','minspan','start','end','span','bins','usenull','useother','otherstr','nullstr'],
          "sirare" => ['showcount','showperc','limit','countfield','percentfield','useother','otherstr'],
          "sistats" => ['partitions','allnum','delim'],
          "sitimechart" => ['sep','format','fixedrange','partial','cont','limit','minspan','bins','usenull','useother','nullstr','otherstr'],
          "sitop" => ['showcount','showperc','limit','countfield','percentfield','useother','otherstr'],
          "sort" => [''],
          "spath" => ['output','path','input'],
          "stats" => ['partitions','allnum','delim'],
          "strcat" => ['allrequired'],
          "streamstats" => ['reset_on_change','current','window','time_window','global','allnum','reset_before'],
          "table" => [''],
          "tags" => ['outputfield','inclname','inclvalue'],
          "tail" => [''],
          "timechart" => ['sep','format','fixedrange','partial','cont','limit','minspan'],
          "timewrap" => ['time_format','align','series'],
          "top" => ['showcount','showperc','limit','countfield','percentfield','useother','otherstr'],
          "transaction" => ['name','maxspan','maxopentxn','delim','maxpause','maxevents','connected','unifyends','keeporphans','maxopenevents','keepevicted','mvlist','nullstr','mvraw','startswith','endswith'],
          "transpose" => ['column_name','header_field','include_empty'],
          "trendline" => ['sma','ema','wma'],
          "tstats" => ['prestats','local','append','summariesonly','allow_old_summaries','span','sid','datamodel','chunk_size','savedsearch','savedsplunk','field'],
          "typeahead" => ['max_time','index','collapse','prefix','count'],
          "typer" => [''],
          "union" => ['extendtimerange','maxtime','maxout','timeout'],
          "uniq" => [''],
          "untable" => [''],
          "where" => [''],
          "x11" => ['mult','add'],
          "xmlkv" => ['maxinputs'],
          "xmlunescape" => ['maxinputs'],
          "xpath" => ['field','outfield','default'],
          "xyseries" => ['grouped','sep','format']
        };
      end
      
      # Some commands use specific operators, some even require them to be in upper case, but we will not make sure of that here
      def self.command_operators
        @command_operators = {
          "bin"  => ['as'],
          "chart" => ['where','over','not','and','or','xor','like','by','as'],
          "convert"  => ['as'],
          "dedup"  => ['sortby'],
          "delta"  => ['as'],
          "eval" => ['and','or','xor','not','like'],
          "eventstats" => ['by','as'],
          "fieldformat"  => ['and','or','xor','not','like'],
          "geostats" => ['as'],
          "head" => ['and','or','xor','not','like'],
          "inputcsv" => ['where'],
          "inputlookup"  => ['where'],
          "join" => ['where'],
          "lookup" => ['outputnew','output','as'],
          "metasearch" => ['in'],
          "mstats" => ['as'],
          "predict" => ['as'],
          "rare" => ['by'],
          "redistribute" => ['by'],
          "replace" => ['with','in'],
          "rename" => ['as'],
          "search" => ['by','where','over','and','or','xor','not','term','in','case'],
          "set" => ['union','diff','intersect'],
          "sichart" => ['by','where','over','and','or','xor','not','as'],
          "sirare" => ['by'],
          "sistats" => ['by','as'],
          "sitimechart" => ['like','not','and','or','xor','where','like','by','as'],
          "sitop" => ['by'],
          "sort" => ['auto','str','ip','num','desc','d'],
          "stats" => ['by','as'],
          "stremstats" => ['like','not','and','or','xor','where','like','by','as'],
          "timechart" => ['like','not','and','or','xor','where','by','as'],
          "top" => ['by'],
          "trendline" => ['as'],
          "tstats" => ['like','not','and','or','xor','where','by','in','groupby','as'],
          "where" => ['like','not','and','or','xor','like'],
          "x11" => ['as']
        };
      end
      
      # Available evaluation functions
      def self.eval_functions
        @eval_functions = ['abs','case','ceiling','cidrmatch','coalesce','commands','exact','exp','false','floor','if','ifnull','isbool','isint','isnotnull','isnull','isnum','isstr','len','like','ln','log','lower','match','max','md5','min','mvappend','mvcount','mvdedup','mvindex','mvfilter','mvfind','mvjoin','mvrange','mvsort','mvzip','now','null','nullif','pi','pow','random','relative_time','replace','round','searchmatch','sha1','sha256','sha512','sigfig','spath','split','sqrt','strftime','strptime','substr','time','tostring','trim','ltrim','rtrim','true','typeof','upper','urldecode','validate','tonumber','acos','acosh','asin','asinh','atan','atan2','atanh','cos','cosh','hypot','sin','sinh','tan','tanh']
      end
      
      # Commands which support evaluation functions (and only those)
      def self.eval_commands
        @eval_commands = ['eval','head','where']
      end
      
      # Available aggregation functions (+ eval which is just a link between eval and aggregation)
      def self.aggr_functions
        @aggr_functions = ['eval','sparkline','c','count','dc','distinct_count','mean','avg','stdev','stdevp','var','varp','sum','sumsq','min','max','mode','median','earliest','first','last','latest','perc','p','exactperc','upperperc','list','values','range','estdc','estdc_error','earliest_time','latest_time','perc70','perc80','perc90','perc91','perc92','perc93','perc94','perc95','perc96','perc97','perc98','perc99']
      end
      
      # Commands which support aggregation functions (and eval functions consequently through the "eval()" function)
      def self.aggr_commands
        @aggr_commands = ['chart','eventstats','geostats','mstats','sichart','sistats','sitimechart','stats','streamstats','timechart','tstats']
      end
      
      # Stack of commands being ran (usually only 1 but it can be more if can of subsearches)
      command_stack = Array.new
      
      state :root do
        rule %r/(?=.)/, Text, :query
      end
      
      state :query do
        rule %r/\|/, Text, :command_start
        # By default, we assume it is an implict search command
        rule %r/(?=.)/ do |m|
          command_stack.push "search"
          token Text
          push :command_start
          push :command_args
        end
      end
      
      state :subquery do
        rule %r/\]/ do |m|
          # At the end of a subsearch, we need to clear the last command context
          if command_stack.length > 0
            command_stack.pop
          end
          token Punctuation
          pop!
        end
        rule %r/\|/, Text, :command
        rule %r/\w+(?=[ \t]*)(?=\=)/ do |m|
          # We can find filters or arguments already
          # By default we assume we were in an implicit search command
          command_stack.push "search"
          if self.class.command_arguments["search"].include? m[0].downcase
            token Keyword::Reserved
          else
            token Text
          end
          # Jumping straight into the command_args context, skipping command_start
          push :command_start
          push :command_args
        end
        # Sub-queries do not need a leading | when running a command
        # Trying to avoid to match an argument
        rule %r/\w+(?=[ \t]*)(?!\=)/ do |m|
          if m[0].downcase == "search"
            token Name::Builtin
            command_stack.push(m[0].downcase)
            # Jumping straight into the command_args context, skipping command_start
            push :command_start
            push :command_args
          elsif self.class.command_arguments.key? m[0].downcase
            token Name::Builtin
            command_stack.push(m[0].downcase)
            push :command_args
          else
            token Text
          end
        end
        # By default, we assume it is an implict search command
        rule %r/(?=.)/ do |m|
          command_stack.push "search"
          token Text
          # Jumping straight into the command_args context, skipping command_start
          push :command_start
          push :command_args
        end
      end
      
      # Search commands have a specific status, being implicit in some situations
      # Consequently, once we can infer we have a search command, we can jump straight to args
      
      # Other commands not being implicit, we will here only handle the initial part "| command_name" and then jump into arguments if any
      state :command_start do
        rule %r/\s+/m, Text
        # Highlighting only known Splunk commands
        rule %r/\w+/m do |m|
          if self.class.command_arguments.key? m[0].downcase
            token Name::Builtin
            command_stack.push(m[0].downcase)
          else
            command_stack.push "unknown"
            token Text
          end
          push :command_args
        end
        # When jumping to the next command, clearing last command
        rule %r/\|/ do |m|
          if command_stack.length > 0
            command_stack.pop
          end
          token Punctuation
        end
        rule %r/\[/, Punctuation, :subquery
        # If finding a closing bracket, popping twice to leave the current state AND the subquery state
        rule %r/\]/ do |m|
          token Punctuation
          pop!
          pop!
        end
      end
      
      # Handling arguments after having initialized the command context
      state :command_args do
        rule %r/```/, Comment::Multiline, :multiline_comments
        rule %r/`\s*comment\s*\(\s*"/, Comment::Preproc, :comment_macro
        rule %r/(`)(\s*\w+)([^`]*)(`)/, Comment::Preproc
        rule %r/\s+/m, Text
        rule %r/0[xX][0-9a-fA-F]*/, Num::Hex
        rule %r/[$][+-]*\d*(\.\d*)?/, Num
        rule %r/((\d+(\.\d*)?)|(\.\d+))([eE][\-+]?\d+)?/, Num
        rule %r/[!<>=,%\+\.\*\-\/]+/, Punctuation
        rule %r/[()]/, Punctuation
        # Command arguments, checking it is a known argument for the current command
        rule %r/\w+(?=[ \t]*)(?=\=)/ do |m|
          if self.class.command_arguments.key? command_stack.last
            if self.class.command_arguments[command_stack.last].include? m[0].downcase
              token Keyword::Reserved
            else
              token Text
            end
          else
            token Text
          end
        end
        rule %r/\w+(?=[ \t]*)(?=\()/ do |m|
          if ( self.class.eval_commands.include?(command_stack.last) && self.class.eval_functions.include?(m[0].downcase) )
            token Name::Function
          # Aggregation functions can use eval functions through the "eval()" function
          elsif ( self.class.aggr_commands.include?(command_stack.last) && ( self.class.aggr_functions.include?(m[0].downcase) || self.class.eval_functions.include?(m[0].downcase)) )
            token Name::Function
          else
            token Text
          end
        end
        rule %r/["]/, Str::Escape, :double_string
        rule %r/[']/, Str::Escape, :single_string
        # When jumping to the next command, clearing last command
        rule %r/\|/ do |m|
          if command_stack.length > 0
            command_stack.pop
          end
          token Punctuation
          pop!
          pop!
          push :command_start
        end
        # A subquery can occur anywhere
        rule %r/\[/, Text, :subquery
        # If finding a closing bracket, popping 3 times to leave the following states: :command_args :command :subquery
        rule %r/\]/ do |m|
          token Punctuation
          pop!
          pop!
          pop!
        end
        # Some commands have specific operators available
        rule %r/[^ \t"'\d!<>=,()\[\]]+/m do |m|
          if self.class.command_operators.key? command_stack.last
            if self.class.command_operators[command_stack.last].include? m[0].downcase
              token Operator::Word
            else
              token Text
            end
          else
            token Text
          end
        end
      end
      
      state :multiline_comments do
        rule %r(```), Comment::Multiline, :pop!
        rule %r/./, Comment::Multiline
      end
      
      # The comment macro is used the following way:
      # `comment("Some comments")`
      state :comment_macro do
        rule %r/"\s*\)\s*`/, Comment::Preproc, :pop!
        rule %r/\\./, Comment::Single
        rule %r/[^\\"]+/, Comment::Single
      end
      
      # When found in a rex/regex command, a double string will be a regex
      state :double_string do
        rule %r/\\./ do |m|
          if ( (command_stack.last == "rex") || (command_stack.last == "regex") )
            token Str::Regex
          else
            token Str::Double
          end
        end
        rule %r/["]/, Str::Escape, :pop!
        rule %r/[^\\"]+/ do |m|
          if ( (command_stack.last == "rex") || (command_stack.last == "regex") )
            token Str::Regex
          else
            token Str::Double
          end
        end
      end
      
      state :single_string do
        rule %r/\\./, Str::Single
        rule %r/[']/, Str::Escape, :pop!
        rule %r/[^\\']+/, Str::Single
      end
    end
  end
end