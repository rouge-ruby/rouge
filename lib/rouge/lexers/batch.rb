# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Batch < RegexLexer
      title "Batchfile"
      desc "Windows Batch File"

      tag 'batch'
      aliases 'bat', 'batch', 'dosbatch', 'winbatch'
      filenames '*.bat', '*.cmd'

      mimetypes 'application/bat', 'application/x-bat', 'application/x-msdos-program'

      KEYWORDS = %w(
        if else
        not equ neq lss leq gtr geq
        exist defined
        for in do
        goto call exit
        errorlevel cmdextversion
      ).join('|')

      DEVICES = %w(
        nul aux prn
        con conin$ conout$
      ).join('|')

      DEVICESNUM = %w(
        com lpt
      ).join('|')

      INTERNAL = %w(
        assoc break cd md rd chdir mkdir rmdir
        cls color copy date del erase dir dpath
        echo ftype move pause path prompt
        setlocal endlocal shift start
        time title type ren rename
        ver verify vol
      ).join('|')

      ATTRIBUTES = %w(
        on off disable
        enableextensions enabledelayedexpansion
      ).join('|')

      EXTERNAL = %w(
        addusers admodcmd ansicon arp at attrib
        bcdboot bcdedit bitsadmin browstat
        cacls certreq certutil
        change chcp chkdsk chkntfs choice
        cidiag cipher cleanmgr clip cmd cmdkey
        comp compact compress convert convertcp coreinfo csccmd csvde
        cscript curl
        debug defrag delprof deltree devcon diamond dirquota diruse
        diskpart diskshadow diskuse dism dnscmd doskey driverquery
        dsacls dsadd dsget dsquery dsmod dsmove dsrm dsmgmt dsregcmd
        edlin eventcreate expand extract
        fc fdisk find findstr fltmc forfiles format freedisk fsutil ftp
        getmac gpresult gpupdate help hostname
        icacls ifmember inuse ipconfig kill
        label lgpo lodctr logman logoff logtime
        makecab mapisend mbsacli mem
        mklink mode more mountvol moveuser msg mshta msiexec msinfo32 mstsc
        nbtstat net net1 netdom netsh netstat nlsinfo nltest now nslookup
        ntbackup ntdsutil ntoskrnl ntrights nvspbind
        openfiles
        pathping perms ping popd portqry powercfg pngout
        pnputil print printbrm prncnfg prnmngr procdump
        psexec psfile psgetsid psinfo pskill pslist
        psloggedon psloglist pspasswd psping
        psservice psshutdown pssuspend
        qbasic qgrep qprocess query quser qwinsta
        rasdial recover reg reg1 regdump regedt32
        regsvr32 regini replace reset restore
        rundll32 rmtshare robocopy route rpcping run runas
        sc scandisk schtasks setspn setx sfc
        share shellrunas shortcut shutdown
        sigcheck sleep slmgr sort strings subinacl
        subst sysmon systeminfo
        takeown taskkill tasklist telnet tftp
        timeout tlist touch tracerpt tracert tree tscon
        tsdiscon tskill tttracer typeperf tzutil
        undelete unformat
        verifier vmconnect vssadmin
        w32tm waitfor wbadmin wecutil wevtutil wget
        where whoami windiff winrm winrs wmic wpeutil wpr wusa wuauclt
        wscript
        xcopy
      ).join('|')

      state :basic do
        # Comments
        rule %r/\b(REM)\b.*$/i, Comment
        # Empty Labels
        rule %r/^::.*$/, Comment

        # Labels
        rule %r/:[a-z]+/i, Keyword::Constant

        # Devices
        rule %r/@?\b(#{DEVICES})\s*\b/i, Keyword::Reserved
        rule %r/@?\b(#{DEVICESNUM}[0-9])\s*\b/i, Keyword::Reserved

        # Lang Keywords
        rule %r/@?\b(#{KEYWORDS})\s*\b/i, Name::Builtin::Pseudo
        # Internal Commands
        rule %r/@?\b(#{INTERNAL})\s*\b/i, Name::Builtin::Pseudo
        # External Commands
        rule %r/\b(#{EXTERNAL})(\.exe|\.com)?\s*\b/i, Name::Builtin::Pseudo

        # Arguments to commands
        rule %r/\b(#{ATTRIBUTES})\s*\b/i, Name::Attribute
        rule %r/([\/\-+][A-Z]+)\s*/i, Name::Attribute

        # Variable Expansions
        rule %r/[\%!]+([a-z_$@#]+)[\%!]+/i, Name::Variable
        # For Variables
        rule %r/(\%+~?[A-Z]+\d?)/i, Keyword::Constant

        rule %r/\b(set)\b/i, Keyword::Declaration

        # Operators
        rule %r/[%!()=<>&|~$*@]/, Operator

      end

      state :single_quotes do
        rule %r/[']/, Str::Single, :pop!
        rule %r/[^']+/, Text
      end

      state :double_quotes do
        rule %r/["]/, Str::Double, :pop!
        rule %r/[^"]+/, Text
      end

      state :backtick do
        rule %r/[`]/, Str::Backtick, :pop!
        rule %r/[^`]+/, Text
      end

      state :data do
        rule %r/\s+/, Text
        rule %r/\^/, Str::Escape
        rule %r/[']/, Str::Single, :single_quotes
        rule %r/["]/, Str::Double, :double_quotes
        rule %r/[`]/, Str::Backtick, :backtick
        rule %r/[^=\!\%\*\s()$"'`;\\]+/, Text
      end

      state :paren_inner do
        rule %r/\(/, Operator, :push
        rule %r/\)/, Operator, :pop!
        mixin :root
      end

      state :root do
        mixin :basic
        mixin :data
      end
    end
  end
end
