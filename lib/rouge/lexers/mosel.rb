# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Mosel < RegexLexer
      tag 'mosel'
      filenames '*.mos'
      title "Mosel"
      desc "An optimization language used by Fico's Xpress." 
      # http://www.fico.com/en/products/fico-xpress-optimization-suite
      filenames '*.mos'

      mimetypes 'text/x-mosel'
      
      def self.analyze_text(text)
        return 1 if text =~ /^\s*(model|package)\s+/
      end

      id = /[a-zA-Z_][a-zA-Z0-9_]*/

      ############################################################################################################################
      #  General language lements
      ############################################################################################################################

      keywords = %w(
        and array as 
        boolean break 
        case count counter 
        declarations div do dynamic 
        elif else end evaluation exit 
        false forall forward from function 
        if imports in include initialisations initializations integer inter is_binary is_continuous is_free is_integer is_partint is_semcont is_semint is_sos1 is_sos2 
        linctr list 
        max min mod model mpvar 
        next not of options or 
        package parameters procedure 
        public prod range real record repeat requirements 
        set string sum then 
        to true union until uses 
        version 
        while with write writeln
      )
      
      ############################################################################################################################
      # mmxprs module elements
      ############################################################################################################################
      
      mmxprs_keywords = %w(
        addmipsol
        basisstability
        calcsolinfo clearmipdir clearmodcut command copysoltoinit
        defdelayedrows defsecurevecs delcell
        estimatemarginals
        fixglobal
        getbstat getdualray getiis getiissense getiistype getinfcause getinfeas getlb getloadedlinctrs getloadedmpvars getname getprimalray getprobstat getrange getsensrng getsize getsol getub getvars
        implies indicator isiisvalid isintegral loadbasis
        loadmipsol loadprob
        maximize, minimize
        postsolve
        readbasis readdirs readsol refinemipsol rejectintsol repairinfeas resetbasis resetiis resetsol
        savebasis savemipsol savesol savestate selectsol setbstat setcallback setcbcutoff setgndata setlb setmipdir setmodcut setsol setub setucbdata stopoptimize
        unloadprob
        writebasis writedirs writeprob writesol 
        xor
      )
      
      mmxpres_constants = %w(XPRS_OPT  XPRS_UNF  XPRS_INF XPRS_UNB XPRS_OTH)
      
      mmxprs_parameters = %w( XPRS_colorder XPRS_enumduplpol XPRS_enummaxsol XPRS_enumsols XPRS_fullversion XPRS_loadnames XPRS_problem XPRS_probname XPRS_verbose)
      
      
      ############################################################################################################################
      # mmsystem module elements
      ############################################################################################################################
      
      mmsystem_keywords = %w(
        addmonths
        copytext cuttext
        deltext 
        endswith expandpath
        fcopy fdelete findfiles findtext fmove
        getasnumber getchar getcwd getdate getday getdaynum getdays getdirsep 
        getendparse setendparse
        getenv getfsize getfstat getftime gethour getminute getmonth getmsec getpathsep
        getqtype, setqtype
        getsecond
        getsepchar, setsepchar
        getsize
        getstart, setstart
        getsucc, setsucc
        getsysinfo getsysstat gettime
        gettmpdir 
        gettrim, settrim
        getweekday getyear
        inserttext isvalid
        makedir makepath newtar
        newzip nextfield
        openpipe 
        parseextn parseint parsereal parsetext pastetext pathmatch pathsplit
        qsort quote
        readtextline regmatch regreplace removedir removefiles 
        setchar setdate setday setenv sethour
        setminute setmonth setmsec setsecond settime setyear sleep startswith system
        tarlist textfmt tolower toupper trim
        untar unzip
        ziplist
      )
      
      mmsystem_parameters = %w(datefmt datetimefmt monthnames sys_endparse sys_fillchar sys_pid sys_qtype sys_regcache sys_sepchar)

      ############################################################################################################################
      # mmjobs  module elements
      ############################################################################################################################
      
      mmjobs_instance_mgmt_keywords = %w(
        clearaliases connect
        disconnect
        findxsrvs
        getaliases getbanner gethostalias
        sethostalias
      )
      
      mmjobs_model_mgmt_keywords = %w(
        compile
        detach
        getannidents getannotations getexitcode getgid getid getnode getrmtid getstatus getuid
        load
        reset resetmodpar run
        setcontrol setdefstream setmodpar setworkdir stop
        unload
      )
      
      mmjobs_synchornization_keywords = %w(
        dropnextevent
        getclass getfromgid getfromid getfromuid getnextevent getvalue
        isqueueempty
        nullevent
        peeknextevent
        send setgid setuid
        wait waitfor
      )
      
      mmjobs_keywords = mmjobs_instance_mgmt_keywords + mmjobs_model_mgmt_keywords + mmjobs_synchornization_keywords
      
      mmjobs_parameters = %w(conntmpl defaultnode fsrvdelay fsrvnbiter fsrvport jobid keepalive nodenumber parentnumber)


      state :whitespace do
        # Spaces
        rule /\s+/m, Text
        # ! Comments
        rule %r((!).*$\n?), Comment::Single
        # (! Comments !)
        rule %r(\(!.*?!\))m, Comment::Multiline

      end

      state :root do
        mixin :whitespace

        rule %r{((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]+))((e|E)(\+|-)?[0-9]+)?)(L|l|UL|ul|u|U|F|f|ll|LL|ull|ULL)?}, Num
        rule %r{[~!@#\$%\^&\*\(\)\+`\-={}\[\]:;<>\?,\.\/\|\\]}, Punctuation
        rule %r{'([^']|'')*'}, Str
        rule /"(\\\\|\\"|[^"])*"/, Str
        rule /(true|false)\b/i, Name::Builtin
        rule /\b(#{keywords.join('|')})\b/i, Keyword
        
        rule /\b(#{mmxprs_keywords.join('|')})\b/i, Keyword::Namespace
        rule /\b(#{mmxpres_constants.join('|')})\b/, Name::Constant
        rule /\b(#{mmxprs_parameters.join('|')})\b/i, Name::Builtin
                  
        rule /\b(#{mmsystem_keywords.join('|')})\b/i, Keyword::Namespace
        
        rule /\b(#{mmjobs_keywords.join('|')})\b/i, Keyword::Namespace
        rule /\b(#{mmjobs_parameters.join('|')})\b/i, Name::Builtin
          
        rule id, Name
      end
    end
  end
end
