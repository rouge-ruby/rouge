# frozen_string_literal: true

require_relative 'xml'
require_relative 'csharp'

module Rouge
  module Lexers
    class BIML < XML
      title "BIML"
      desc "BIML, Business Intelligence Markup Language"
      tag 'biml'
      filenames '*.biml'

      def self.detect?(text)
        return true if text =~ /<\s*Biml\b/
      end

      start do
        @csharp = CSharp.new(options)
      end

      state :biml_interp do
        rule %r(<#[=]?)m do
          token Name::Tag
          push :directive_as_csharp
        end
      end

      prepend :root do
        rule %r(<#\@\s*)m, Name::Tag, :directive_tag

        mixin :biml_interp
      end

      prepend :attr do
        rule(%r/"/) { token Str::Double; goto :biml_dq }
        rule(%r/'/) { token Str::Double; goto :biml_sq }

        mixin :biml_interp
      end

      state :biml_dq do
        rule %r/[^<"]+/, Str::Double
        mixin :biml_interp
        rule %r/"/, Str::Double, :pop!
        rule %r/</, Str::Double
      end

      state :biml_sq do
        rule %r/[^<']+/, Str::Single
        mixin :biml_interp
        rule %r/'/, Str::Single, :pop!
        rule %r/</, Str::Single
      end

      state :directive_as_csharp do
        rule(/[^#]+/) { delegate @csharp }
        rule %r/#>/, Name::Tag, :pop!
        rule(/[#>]/) { delegate @csharp }
      end

      state :directive_tag do
        rule %r/\s+/m, Text
        rule %r/[\w.:-]+\s*=/m, Name::Attribute, :attr
        rule %r/\w+\s*/m, Name::Attribute
        rule %r(/?\s*#>), Name::Tag, :pop!
      end
    end
  end
end
