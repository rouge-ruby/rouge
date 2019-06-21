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

      # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-6
      ATTRIBUTES = %w(
        CmdletBinding ConfirmImpact DefaultParameterSetName HelpURI SupportsPaging
        SupportsShouldProcess PositionalBinding
      ).join('|')
      
      # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_reserved_words?view=powershell-6
      KEYWORDS = %w(
        assembly exit process
        base filter public
        begin finally return
        break for sequence
        catch foreach static
        class from switch
        command function throw
        configuration hidden trap
        continue if try
        data in type
        define inlinescript until
        do interface using
        dynamicparam module var
        else namespace while
        elseif parallel workflow
        end param
        enum private
      ).join('|')
      
      # https://devblogs.microsoft.com/scripting/powertip-find-a-list-of-powershell-type-accelerators/
      # ([PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get).Keys -join ' '
      KEYWORDS_TYPE = %w(
        Alias AllowEmptyCollection AllowEmptyString AllowNull ArgumentCompleter array bool byte char 
        CmdletBinding datetime decimal double DscResource float single guid hashtable int int32 int16
         long int64 ciminstance cimclass cimtype cimconverter IPEndpoint NullString OutputType 
         ObjectSecurity Parameter PhysicalAddress pscredential PSDefaultValue pslistmodifier psobject 
         pscustomobject psprimitivedictionary ref PSTypeNameAttribute regex DscProperty sbyte string 
         SupportsWildcards switch cultureinfo bigint securestring timespan uint16 uint32 uint64 uri 
         ValidateCount ValidateDrive ValidateLength ValidateNotNull ValidateNotNullOrEmpty 
         ValidatePattern ValidateRange ValidateScript ValidateSet ValidateTrustedData 
         ValidateUserDrive version void ipaddress DscLocalConfigurationManager WildcardPattern 
         X509Certificate X500DistinguishedName xml CimSession adsi adsisearcher wmiclass wmi 
         wmisearcher mailaddress scriptblock psvariable type psmoduleinfo powershell runspacefactory 
         runspace initialsessionstate psscriptmethod psscriptproperty psnoteproperty psaliasproperty 
         psvariableproperty
      ).join('|')

      OPERATORS = %w(
        -split -isplit -csplit -join -is -isnot -as -eq -ieq -ceq -ne -ine
        -cne -gt -igt -cgt -ge -ige -cge -lt -ilt -clt -le -ile -cle -like
        -ilike -clike -notlike -inotlike -cnotlike -match -imatch -cmatch
        -notmatch -inotmatch -cnotmatch -contains -icontains -ccontains
        -notcontains -inotcontains -cnotcontains -replace -ireplace
        -creplace -band -bor -bxor -and -or -xor \. & = \+= -= \*= \/= %=
      ).join('|')

      MULTILINEKEYWORDS = %w(
        synopsis description parameter example inputs outputs notes link component 
        role functionality forwardhelptargetname forwardhelpcategory remotehelprunspace
        externalhelp 
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

      state :hashtable do 
        rule %r/\w+/, Name::Variable
        rule %r/}/, Operator, :pop!
        mixin :root
      end

      state :multiline do
        rule %r/\.(#{MULTILINEKEYWORDS})/i, Keyword::Pseudo
        rule %r/[\w\s\.\-\,:\/{}<>"*]/, Comment
        rule %r/#>/, Comment, :pop!
        mixin :root
      end

      state :heredoc do
        rule %r/"@/, Operator, :pop!
        #rule %r/[^$\n]+/, Str::Heredoc
        rule %r/[$]/, Str::Heredoc
        mixin :data
      end

      prepend :basic do
        rule %r(#requires\s-version \d.\d*$),Comment::Preproc
        rule %r(<#), Comment, :multiline
        rule %r(@{), Operator, :hashtable
        rule %r(@"), Operator, :heredoc
        rule %r/\b(#{OPERATORS})\s*\b/i, Operator
        rule %r/\b(#{ATTRIBUTES})\s*\b/i, Name::Builtin::Pseudo
        rule %r/[a-zA-Z\d]+?-[a-zA-Z\d]*/, Name::Function
        rule %r/\b(#{KEYWORDS})\b/i, Keyword
        rule %r/\b(#{KEYWORDS_TYPE})\s*\b/i, Keyword::Type
        rule %r/\bcase\b/, Keyword, :case
      end
    end
  end
end