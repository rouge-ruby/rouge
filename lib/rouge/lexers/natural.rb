# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Natural < RegexLexer
      title 'Natural'
      desc 'Natural is a programming language developed by Software AG for the Adabas database'
      tag 'natural'
      filenames '*.NSA', '*.NSC', '*.NSD', '*.NSF', '*.NSG', '*.NSH', '*.NSL', '*.NSM', '*.NSN', '*.NSP', '*.NSS', '*.NST', '*.NSR', '*.NS7'
      mimetypes 'text/x-natural'

      identifier = /[a-zA-Z0-9-]+/

      # Palavras-chave extraídas do seu repositório tmLanguage
      def self.keywords
        @keywords ||= Set.new(%w(
          ADD ASSIGN AT CALL CALLNAT CLOSE COMPUTE COMPRESS DECIDE DEFINE
          DELETE DISPLAY DIVIDE DO ELSE END END-DECIDE END-DEFINE END-FIND
          END-FOR END-FUNCTION END-IF END-NOREC END-READ END-REPEAT
          END-SUBROUTINE ESCAPE EXAMINE FETCH FIND FOR FORMAT GET
          HISTOGRAM IF INPUT MOVE MULTIPLY PERFORM PRINT READ REPEAT
          RESET REINPUT RETURN SELECT SET SKIP STOP STORE SUBTRACT
          TERMINATE UPDATE VALUE WHEN WHILE WRITE
        ))
      end

      # Palavras-chave específicas de definição de dados
      def self.data_keywords
        @data_keywords ||= Set.new(%w(
          WITH VIEW VALUE RESULT REDEFINE PARAMETER OPTIONAL OF OBJECT
          LOCAL INIT INDEPENDENT GLOBAL DYNAMIC CONTEXT CONSTANT CONST BY
        ))
      end

      # Operadores lógicos e aritméticos
      def self.operators
        @operators ||= Set.new(%w(
          THRU OR NOTEQUAL NOT NE LT LE GT GE EQ AND BUT MASK SCAN
        ))
      end

      state :root do
        # Comentários: Suporta ^* e /*
        rule %r/(^\*.*$|\/\*.*$)/, Comment::Single

        # Variáveis de Sistema: Iniciadas com *
        rule %r/(?i)\*(winmgrvers|username|user|tpvers|time|timn|program|pid|pf-key|pagesize|page-number|osvers|opsys|number|natvers|isn|init-user|hostname|error-nr|error-line|datx|datn|date|counter|applic-id)/, Name::Variable::Global

        # Variáveis locais iniciadas com #
        rule %r/\#[a-zA-Z0-9-]+/, Name::Variable

        # Strings
        rule %r/'/, Str::Single, :string_single
        rule %r/"/, Str::Double, :string_double

        # Datas e Horas: EX: D'2023-10-25'
        rule %r/([tTdDeE]?)\'[0-9:\/\.\-]+\'/, Literal::Date

        # Números
        rule %r/(?<![\w-])[+-]?[0-9]+[,.]?[0-9]*(?![\w-])/, Num

        # Definições de Tipo (A20), (N10.2)
        rule %r/(?<=\()(?i:[abu][0-9]*|[np][0-9\.,]+|i0*[148]|f0*[48]|[cdlt])/, Keyword::Type

        # Níveis de variável no DEFINE DATA (Ex: 01, 02)
        rule %r/^\s*[0-9]+/, Name::Label

        # Identificadores (Keywords vs Names)
        rule %r/#{identifier}/ do |m|
          name = m[0].upcase
          if self.class.keywords.include?(name)
            token Keyword
          elsif self.class.data_keywords.include?(name)
            token Keyword::Declaration
          elsif self.class.operators.include?(name)
            token Operator::Word
          else
            token Name
          end
        end

        # Operadores simbólicos
        rule %r/[+\-*\/><=:=]/, Operator

        # Pontuação
        rule %r/[.,;:()]/, Punctuation

        # Whitespace
        rule %r/\s+/, Text::Whitespace
      end

      state :string_single do
        rule %r/[^'\n]+/, Str::Single
        rule %r/''/, Str::Escape
        rule %r/'/, Str::Single, :pop!
        rule %r/\n/, Error
      end

      state :string_double do
        rule %r/[^"\n]+/, Str::Double
        rule %r/""/, Str::Escape
        rule %r/"/, Str::Double, :pop!
        rule %r/\n/, Error
      end
    end
  end
end
