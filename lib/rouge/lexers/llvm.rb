module Rouge
  module Lexers
    class LLVM < RegexLexer
      desc 'The LLVM Compiler Infrastructure (http://llvm.org/)'
      tag 'llvm'

      filenames '*.ll'
      mimetypes 'text/x-llvm'

      def self.analyze_text(text)
        return 1 if text =~ /\A%\w+\s=\s/
      end

      state :root do

      end
    end
  end
end
