# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
  module Lexers
    class Scad < Go
      title "Scad"
      desc 'The OpenSCAD 3D programming language (https://openscad.org/documentation.html#language-reference)'
      tag 'scad'
      aliases 'scad', 'openscad'
      filenames '*.scad'

      mimetypes 'text/x-scad'

      # This lexer is inherited from the go lexer, which looks clear and conchise :-)
      # Those definitions which are different for OpenSCAD are overwritten and the 
      # states are modified to add the required and remove the unused regexp

      # Keywords related to OpenSCAD

      KEYWORD                = /\b(?:
                                 function | module | if | else | let | for | intersection_for
                                 )\b/x


      # Operators and delimiters related to OpenSCAD

      OPERATOR               = / \+  | -    | \*  
                               | %   | \^
                               | <=  | <    | >= | >    
                               | !=  | ==   | =  | \!
                               | &&  | \|\| 
                               | \/  | \#
                               /x

      SEPARATOR              = / \(     | \)     | \[     | \]     | \{
                               | \}     | ,      | ;      | \:     | \?
                               /x

      # Literals related to OpenSCAD
      INT_LIT                = /#{DECIMAL_LIT}/
      ESCAPED_CHAR           = /\\[nrt\\"]/
      CHAR_LIT               = /'(?:#{UNICODE_VALUE})'/

      # Predeclared identifiers related to OpenSCAD

      SPECIAL_VARIABLES      = /\$(fa|fs|fn|t|vpr|vpt|vpd|vpf|children|preview|parent_modules)/

      PREDECLARED_CONSTANTS  = /\b(?:true|false|PI|undef)\b/

      PREDECLARED_FUNCTIONS  = /\b(?:
                                 circle    | square      | polygon  | text
                               | sphere    | cube        | cylinder | polyhedron
                               | translate | rotate      | scale    | resize 
                               | mirror    | multimatrix | color    | offset 
                               | hull      | minkowski
                               | union     | difference  | intersection
                               | is_undef  | is_bool     | is_num   | is_string 
                               | is_list   | is_function
                               | concat    | lookup      | str      | chr 
                               | ord       | search      | version  | version_num 
                               | parent_module
                               | abs       | sign        | sin      | cos 
                               | tan       | acos        | asin     | atan 
                               | atan2     | floor       | round    | ceil 
                               | ln        | len         | let      | log 
                               | pow       | sqrt        | exp      | rands 
                               | min       | max         | norm     | cross
                               | echo      | render      | surface  | assert
                               )\b/x

      state :root do
        mixin :include_or_use
        mixin :simple_tokens
        rule(/"/, Str, :interpreted_string)
      end
                        
      state :simple_tokens do
        rule(COMMENT,               Comment)
        rule(KEYWORD,               Keyword)
        rule(SPECIAL_VARIABLES,     Name::Variable)
        rule(PREDECLARED_FUNCTIONS, Name::Builtin)
        rule(PREDECLARED_CONSTANTS, Name::Constant)
        rule(FLOAT_LIT,             Num)
        rule(INT_LIT,               Num)
        rule(CHAR_LIT,              Str::Char)
        rule(OPERATOR,              Operator)
        rule(SEPARATOR,             Punctuation)
        rule(IDENTIFIER,            Name)
        rule(WHITE_SPACE,           Text)
      end

      # use or include are somehow special:
      # Although they are keywords, they are valid only in combination with
      # <subdir_and_filename> which uses the < and > which normally are operators
      # Here they are used as punctuation and the path is highlighted as an
      # ordinary string value even without the delimiting "".
      state :include_or_use do
        rule /^#{WHITE_SPACE}*(include|use)(#{WHITE_SPACE}+)(<)(.*)(>).*([\n])/ do
          groups Keyword, Text, Punctuation, Str, Punctuation, Text
        end
      end

    end
  end
end
