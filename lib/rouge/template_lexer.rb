module Rouge
  class TemplateLexer < RegexLexer
    def parent
      return @parent if instance_variable_defined? :@parent
      @parent = option(:parent) || 'html'
      if @parent.is_a? String
        lexer_class = Lexer.find(@parent)
        @parent = lexer_class.new(self.options)
      end
    end

    start { parent.reset! }
  end
end
