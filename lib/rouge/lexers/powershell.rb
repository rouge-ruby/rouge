# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    load_lexer 'shell.rb'

    class Powershell < Shell
      title 'powershell'
      desc 'powershell'
      tag 'powershell'
      aliases 'posh', 'microsoftshell', 'msshell'
      filenames '*.ps1', '*.psm1', '*.psd1', '*.psrc', '*.pssc'
      mimetypes 'text/x-powershell'

      ATTRIBUTES = %w(
        CmdletBinding ConfirmImpact DefaultParameterSetName HelpURI SupportsPaging
        SupportsShouldProcess PositionalBinding
      ).join('|')

      KEYWORDS = %w(
        Begin Exit Process Break Filter Return Catch Finally Sequence Class For
        Switch Continue ForEach Throw Data From Trap Define Function Try Do If
        Until DynamicParam In Using Else InlineScript Var ElseIf Parallel While
        End Param Workflow
      ).join('|')

      KEYWORDS_TYPE = %w(
        bool byte char decimal double float int long object sbyte
        short string uint ulong ushort
      ).join('|')

      OPERATORS = %w(
        -split -isplit -csplit -join -is -isnot -as -eq -ieq -ceq -ne -ine
        -cne -gt -igt -cgt -ge -ige -cge -lt -ilt -clt -le -ile -cle -like
        -ilike -clike -notlike -inotlike -cnotlike -match -imatch -cmatch
        -notmatch -inotmatch -cnotmatch -contains -icontains -ccontains
        -notcontains -inotcontains -cnotcontains -replace -ireplace
        -creplace -band -bor -bxor -and -or -xor \. & = \+= -= \*= \/= %=
      ).join('|')

      BUILTINS = %w(
        Add-\w+ Approve-\w+ Assert-\w+ Backup-\w+ Block-\w+
        Build-\w+ Checkpoint-\w+ Clear-\w+ Close-\w+ Compare-\w+
        Complete-\w+ Compress-\w+ Confirm-\w+ Connect-\w+ Convert-\w+
        ConvertFrom-\w+ ConvertTo-\w+ Copy-\w+ Debug-\w+ Deny-\w+
        Deploy-\w+ Disable-\w+ Disconnect-\w+ Dismount-\w+ Edit-\w+
        Enable-\w+ Enter-\w+ Exit-\w+ Expand-\w+ Export-\w+
        Find-\w+ Format-\w+ Get-\w+ Grant-\w+ Group-\w+
        Hide-\w+ Import-\w+ Initialize-\w+ Install-\w+ Invoke-\w+
        Join-\w+ Limit-\w+ Lock-\w+ Measure-\w+ Merge-\w+
        Mount-\w+ Move-\w+ New-\w+ Open-\w+ Optimize-\w+
        Out-\w+ Ping-\w+ Pop-\w+ Protect-\w+ Publish-\w+
        Push-\w+ Read-\w+ Receive-\w+ Redo-\w+ Register-\w+
        Remove-\w+ Rename-\w+ Repair-\w+ Request-\w+ Reset-\w+
        Resolve-\w+ Restart-\w+ Restore-\w+ Resume-\w+ Revoke-\w+
        Save-\w+ Search-\w+ Select-\w+ Send-\w+ Set-\w+
        Show-\w+ Skip-\w+ Split-\w+ Start-\w+ Step-\w+
        Stop-\w+ Submit-\w+ Suspend-\w+ Switch-\w+ Sync-\w+
        Test-\w+ Trace-\w+ Unblock-\w+ Undo-\w+ Uninstall-\w+
        Unlock-\w+ Unprotect-\w+ Unpublish-\w+ Unregister-\w+ Update-\w+
        Use-\w+ Wait-\w+ Watch-\w+ Write-\w+
        Apply-\w+ Begin-\+ End-\w+ ForEach-\w+ Flush-\w+ Resize-\w+ Sort-\w+ Tee-\w+
        \% \? ac asnp cat cd chdir clc clear
        clhy cli clp cls clv cnsn compare copy cp cpi cpp curl cvpa dbp del diff dir
        dnsn ebp echo epal epcsv epsn erase etsn exsn fc fl foreach ft fw gal gbp gc
        gci gcm gcs gdr ghy gi gjb gl gm gmo gp gps gpv group gsn gsnp gsv gu gv gwmi h
        history icm iex ihy ii ipal ipcsv ipmo ipsn irm ise iwmi iwr kill lp ls man md
        measure mi mount move mp mv nal ndr ni nmo npssc nsn nv ogv oh popd ps pushd
        pwd r rbp rcjb rcsn rd rdr ren ri rjb rm rmdir rmo rni rnp rp rsn rsnp rujb rv
        rvpa rwmi sajb sal saps sasv sbp sc select set shcm si sl sleep sls sort sp
      ).join('|')

      # Override from Shell
      state :interp do
        rule %r/`$/, Str::Escape # line continuation
        rule %r/`./, Str::Escape
        rule %r/\$\(\(/, Keyword, :math
        rule %r/\$\(/, Keyword, :paren
        rule %r/\${#?/, Keyword, :curly
        rule %r/\$#?(\w+|.)/, Name::Variable
      end

      # Override from Shell
      state :double_quotes do
        # NB: "abc$" is literally the string abc$.
        # Here we prevent :interp from interpreting $" as a variable.
        rule %r/(?:\$#?)?"/, Str::Double, :pop!
        mixin :interp
        rule %r/[^"`$]+/, Str::Double
      end

      # Override from Shell
      state :data do
        rule %r/\s+/, Text
        rule %r/\$?"/, Str::Double, :double_quotes
        rule %r/\$'/, Str::Single, :ansi_string

        rule %r/'/, Str::Single, :single_quotes

        rule %r/\*/, Keyword

        rule %r/;/, Text
        rule %r/[^=\*\s{}()$"'`<]+/, Text
        rule %r/\d+(?= |\Z)/, Num
        rule %r/</, Text
        mixin :interp
      end

      prepend :basic do
        rule %r(<#[\s,\S]*?#>)m, Comment::Multiline
        rule %r/#.*$/, Comment::Single
        rule %r/\b(#{OPERATORS})\s*\b/i, Operator
        rule %r/\b(#{ATTRIBUTES})\s*\b/i, Name::Attribute
        rule %r/\b(#{KEYWORDS})\s*\b/i, Keyword
        rule %r/\b(#{KEYWORDS_TYPE})\s*\b/i, Keyword::Type
        rule %r/\bcase\b/, Keyword, :case
        rule %r/\b(#{BUILTINS})\s*\b(?!\.)/i, Name::Builtin
      end
    end
  end
end
