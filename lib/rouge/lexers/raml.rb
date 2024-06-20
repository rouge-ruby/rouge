# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'yaml.rb'
    
    class RAML < YAML
      title "RAML"
      desc "Everyday I'm RAML-ing"
      mimetypes 'application/raml+yaml'
      tag 'raml'
      aliases 'raml'
      filenames '*.raml'

      def self.detect?(text)
        # look for the %RAML directive
        return true if text =~ /\A\s*%RAML/m
      end
     end
   end
 end
