# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'csharp.rb'

    class Cake < CSharp
      tag 'cake'
      aliases 'cake'
      filenames '*.cake'
      mimetypes 'text/x-cake'

      title "Cake (C# Make)"
      desc 'A cross platform build automation system with a C# DSL'

      preprocessor_keywords = %w(
        addin break l load r reference tool
      )

      reference_keywords = %w(
        Task IsDependentOn RunTarget
      )

      keywords = %w(
        Does WithCriteria
        Argument EnvironmentVariable
        ContinueOnError Finally OnError ReportError
        Setup TaskSetup TaskTeardown Teardown
      )

      prepend :root do
        rule /^#[ \t]*(#{preprocessor_keywords.join('|')})\b.*?\n/, Comment::Preproc
        rule /(#{reference_keywords.join('|')})/, Keyword, :task
        rule /\b(#{keywords.join('|')})\b/, Keyword
      end

      state :task do
        rule /\(/, Punctuation
        rule /\"[\.\w-]+\"/, Literal::String::Symbol, :pop!
        rule /[^\(\)]/, Text, :pop!
      end
    end
  end
end
