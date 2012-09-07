module Rouge
  class TextAnalyzer < String
    def shebang
      return @shebang if instance_variable_defined? :@shebang

      self =~ /\A\s*#!(.*)$/
      @shebang = $1
    end

    def shebang?(match)
      match = /\b#{match}(\s|$)/
      match === shebang
    end

    def doctype
      return @doctype if instance_variable_defined? :@doctype

      self =~ %r(\A\s*
        (?:<\?.*?\?>\s*)? # possible <?xml...?> tag
        <!DOCTYPE\s+(.+?)>
      )xm
      @doctype = $1
    end

    def doctype?(type)
      type === doctype
    end

    def lexes_cleanly?(lexer)
      lexer.lex(self) do |(tok, _)|
        return false if tok.name == 'Error'
      end

      true
    end
  end
end
