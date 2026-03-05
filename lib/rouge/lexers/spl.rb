# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class SPL < RegexLexer
      title "SPL"
      desc "Splunk Search Processing Language (SPL)"
      tag 'spl'
      aliases 'splunk', 'splunk-spl'
      filenames '*.spl', '*.splunk'
      mimetypes 'text/x-spl'

      def self.detect?(text)
        return true if text =~ /^\s*\|\s*(stats|eval|table|search|where|rex|rename|fields|sort|dedup|timechart|chart|head|tail)\b/i
        return true if text =~ /\bindex\s*=\s*\w+/i && text =~ /\bsourcetype\s*=\s*/i
      end

      # SPL commands (from Splunk command quick reference)
      def self.commands
        @commands ||= Set.new %w(
          abstract accum addcoltotals addinfo addtotals analyzefields
          anomalies anomalousvalue anomalydetection append appendcols
          appendpipe arules associate autoregress bin bucket bucketdir
          chart cluster cofilter collect concurrency contingency convert
          correlate datamodel dbinspect dedup delete delta diff erex eval
          eventcount eventstats extract filldown fillnull findtypes
          folderize foreach format from gauge gentimes geom geomfilter
          geostats head highlight history iconify inputcsv inputlookup
          iplocation join kmeans kvform loadjob localize localop lookup
          makecontinuous makemv makeresults map mcollect metadata
          metasearch meventcollect mpreview msearch mstats multikv
          multisearch mvcombine mvexpand nomv outlier outputcsv
          outputlookup outputtext overlap pivot predict rangemap rare
          redistribute regex reltime rename replace require rest return
          reverse rex rtorder savedsearch script run scrub search
          searchtxn selfjoin sendalert sendemail set setfields sichart
          sirare sistats sitimechart sitop sort spath stats strcat
          streamstats table tags tail timechart timewrap tojson top
          transaction transpose trendline tscollect tstats typeahead
          typelearner typer union uniq untable walklex where x11 xmlkv
          xmlunescape xpath xyseries kv
        )
      end

      # Evaluation functions (from Splunk evaluation functions reference)
      def self.eval_functions
        @eval_functions ||= Set.new %w(
          abs acos acosh asin asinh atan atan2 atanh avg
          bit_and bit_or bit_not bit_xor bit_shift_left bit_shift_right
          case cidrmatch ceiling coalesce commands cos cosh exact exp
          false floor hypot if in ipmask isarray isbool isdouble isint
          ismv isnotnull isnull isnum isobject isstr json json_append
          json_array json_array_to_mv json_delete json_entries
          json_extend json_extract json_extract_exact json_has_key_exact
          json_keys json_object json_set json_set_exact json_valid len
          like ln log lower ltrim match max md5 min mvappend mvcount
          mvdedup mvfilter mvfind mvindex mvjoin mvmap mvrange mvsort
          mvzip mv_to_json_array now null nullif pi pow printf random
          relative_time replace round rtrim searchmatch sha1 sha256
          sha512 sigfig sin sinh split sqrt strftime strptime substr sum
          tan tanh time toarray tobool todouble toint tomv tonumber
          toobject tostring trim true typeof upper urldecode validate
        )
      end

      # Statistical and charting functions (from Splunk stats functions reference)
      def self.stats_functions
        @stats_functions ||= Set.new %w(
          avg count distinct_count dc estdc estdc_error exactperc max
          mean median min mode perc percentile range stdev stdevp sum
          sumsq upperperc var varp first last list values earliest
          earliest_time latest latest_time per_day per_hour per_minute
          per_second rate rate_avg rate_sum sparkline
        )
      end

      # Operator keywords
      def self.operator_words
        @operator_words ||= Set.new %w(
          AND OR NOT XOR IN LIKE BY AS OVER OUTPUT OUTPUTNEW WHERE
        )
      end

      # Constants
      def self.constants
        @constants ||= Set.new %w(
          true false TRUE FALSE null NULL
        )
      end

      # Built-in / internal fields
      def self.builtin_fields
        @builtin_fields ||= Set.new %w(
          _time _raw _indextime _cd _serial _bkt _si _sourcetype
          _subsecond _kv host source sourcetype index splunk_server
          linecount punct timeendpos timestartpos eventtype tag
          date_hour date_mday date_minute date_month date_second
          date_wday date_year date_zone
        )
      end

      state :root do
        # Whitespace
        rule %r/\s+/m, Text

        # Block comments (triple backtick)
        rule %r/```/, Comment::Multiline, :block_comment

        # Single-line comments (starting with ` followed by content)
        # SPL doesn't have single-line comments in the traditional sense

        # Double-quoted strings
        rule %r/"/, Str::Double, :double_string

        # Single-quoted strings (field names)
        rule %r/'/, Str::Single, :single_string

        # Backtick-quoted macros/saved searches (not triple)
        rule %r/`(?!``)/, Name::Function, :backtick_string

        # Numeric literals
        rule %r/-?\d+\.\d+(?:e[+-]?\d+)?/i, Num::Float
        rule %r/-?\d+(?:e[+-]?\d+)?/i, Num::Integer

        # Time modifiers (e.g., -24h@h, +7d@d, -30m, now)
        rule %r/[+-]\d+[smhdwqy](?:@[smhdwqy])?/i, Literal::Date

        # Subsearch brackets
        rule %r/[\[\]]/, Punctuation

        # Pipe operator
        rule %r/\|/, Punctuation

        # Comparison and assignment operators
        rule %r/[<>!=]=?/, Operator
        rule %r/==/, Operator

        # Arithmetic and string concatenation operators
        rule %r/[+\-*\/%]/, Operator
        rule %r/\.\./, Operator
        rule %r/\.(?!\w)/, Operator

        # Other punctuation
        rule %r/[(),;]/, Punctuation

        # Equals sign (assignment / field=value)
        rule %r/=/, Operator

        # Wildcard
        rule %r/\*/, Operator

        # Words — classify by set membership
        rule %r/\w+/ do |m|
          word = m[0]
          word_upper = word.upcase
          word_lower = word.downcase
          if self.class.constants.include? word
            token Keyword::Constant
          elsif self.class.operator_words.include? word_upper
            token Keyword::Pseudo
          elsif self.class.commands.include? word_lower
            token Keyword
          elsif self.class.eval_functions.include? word_lower
            token Name::Builtin
          elsif self.class.stats_functions.include? word_lower
            token Name::Builtin
          elsif self.class.builtin_fields.include? word_lower
            token Name::Variable::Magic
          else
            token Name
          end
        end
      end

      state :block_comment do
        rule %r/```/, Comment::Multiline, :pop!
        rule %r/[^`]+/, Comment::Multiline
        rule %r/`/, Comment::Multiline
      end

      state :double_string do
        rule %r/\\./, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/[^\\"]+/, Str::Double
      end

      state :single_string do
        rule %r/\\./, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/[^\\']+/, Str::Single
      end

      state :backtick_string do
        rule %r/`/, Name::Function, :pop!
        rule %r/[^`]+/, Name::Function
      end
    end
  end
end
