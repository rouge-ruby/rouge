# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Mosel
      ############################################################################################################################
      #  General language lements
      ############################################################################################################################

      CORE_KEYWORDS = Set.new %w(
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
        set string sum
        then to true
        union until uses
        version
        while with
      )

      CORE_FUNCTIONS = Set.new %w(
        abs arctan assert
        bitflip bitneg bitset bitshift bittest bitval
        ceil cos create currentdate currenttime cuthead cuttail
        delcell exists exit exp exportprob
        fclose fflush finalize findfirst findlast floor fopen fselect fskipline
        getact getcoeff getcoeffs getdual getfid getfirst gethead getfname getlast getobjval getparam getrcost getreadcnt getreverse getsize getslack getsol gettail gettype getvars
        iseof ishidden isodd ln log
        makesos1 makesos2 maxlist minlist
        publish
        random read readln reset reverse round
        setcoeff sethidden setioerr setname setparam setrandseed settype sin splithead splittail sqrt strfmt substr
        timestamp
        unpublish
        write writeln
      )

      ############################################################################################################################
      # mmxprs module elements
      ############################################################################################################################

      MMXPRS_FUNCTIONS = Set.new %w(
        addmipsol
        basisstability
        calcsolinfo clearmipdir clearmodcut command copysoltoinit
        defdelayedrows defsecurevecs
        estimatemarginals
        fixglobal
        getbstat getdualray getiis getiissense getiistype getinfcause getinfeas getlb getloadedlinctrs getloadedmpvars getname getprimalray getprobstat getrange getsensrng getsize getsol getub getvars
        implies indicator isiisvalid isintegral loadbasis
        loadmipsol loadprob
        maximize minimize
        postsolve
        readbasis readdirs readsol refinemipsol rejectintsol repairinfeas resetbasis resetiis resetsol
        savebasis savemipsol savesol savestate selectsol setbstat setcallback setcbcutoff setgndata setlb setmipdir setmodcut setsol setub setucbdata stopoptimize
        unloadprob
        writebasis writedirs writeprob writesol
        xor
      )

      MMXPRES_CONSTANTS = Set.new %w(XPRS_OPT  XPRS_UNF  XPRS_INF XPRS_UNB XPRS_OTH)

      MMXPRS_PARAMETERS = Set.new %w(XPRS_colorder XPRS_enumduplpol XPRS_enummaxsol XPRS_enumsols XPRS_fullversion XPRS_loadnames XPRS_problem XPRS_probname XPRS_verbose)


      ############################################################################################################################
      # mmsystem module elements
      ############################################################################################################################

      MMSYSTEM_FUNCTIONS = Set.new %w(
        addmonths
        copytext cuttext
        deltext
        endswith expandpath
        fcopy fdelete findfiles findtext fmove
        getasnumber getchar getcwd getdate getday getdaynum getdays getdirsep
        getendparse setendparse
        getenv getfsize getfstat getftime gethour getminute getmonth getmsec getpathsep
        getqtype setqtype
        getsecond
        getsepchar setsepchar
        getsize
        getstart setstart
        getsucc setsucc
        getsysinfo getsysstat gettime
        gettmpdir
        gettrim settrim
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

      MMSYSTEM_PARAMETERS = Set.new %w(datefmt datetimefmt monthnames sys_endparse sys_fillchar sys_pid sys_qtype sys_regcache sys_sepchar)

      ############################################################################################################################
      # mmjobs  module elements
      ############################################################################################################################

      MMJOBS_FUNCTIONS = Set.new %w(
        clearaliases connect
        disconnect
        findxsrvs
        getaliases getbanner gethostalias
        sethostalias

        compile
        detach
        getannidents getannotations getexitcode getgid getid getnode getrmtid getstatus getuid
        load
        reset resetmodpar run
        setcontrol setdefstream setmodpar setworkdir stop
        unload

        dropnextevent
        getclass getfromgid getfromid getfromuid getnextevent getvalue
        isqueueempty
        nullevent
        peeknextevent
        send setgid setuid
        wait waitfor
      )

      MMJOBS_PARAMETERS = Set.new %w(conntmpl defaultnode fsrvdelay fsrvnbiter fsrvport jobid keepalive nodenumber parentnumber)
    end
  end
end
