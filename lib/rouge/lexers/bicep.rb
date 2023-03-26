module Rouge
  module Lexers
    class Bicep < Rouge::RegexLexer
      tag 'bicep'
      filenames '*.bicep'

      title "Bicep"
      desc 'Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources.'

      def self.keywords
        @keywords ||= Set.new %w(
          resource module param var output targetScope dependsOn
          existing for in if else true false null
        )
      end

      def self.datatypes
        @datatypes ||= Set.new %w(array bool int object string)
      end

      def self.functions
        @functions ||= Set.new %w(
          any array concat contains empty first intersection items last length min max range skip 
          take union dateTimeAdd utcNow deployment environment loadFileAsBase64 loadTextContent int 
          json extensionResourceId getSecret list listKeys listKeyValue listAccountSas listSecrets 
          pickZones reference resourceId subscriptionResourceId tenantResourceId managementGroup 
          resourceGroup subscription tenant base64 base64ToJson base64ToString dataUri dataUriToString 
          endsWith format guid indexOf lastIndexOf length newGuid padLeft replace split startsWith 
          string substring toLower toUpper trim uniqueString uri uriComponent uriComponentToString
          toObject
        )
      end

      operators = %w(+ - * / % < <= > >= == != && || !)

      punctuation = %w(( ) { } [ ] , : ; = .)

      state :root do
          mixin :comments

          # Match strings
          rule %r/'/, Str::Single, :string

          # Match numbers
          rule %r/\b\d+\b/, Num

          # Rules for sets of reserved keywords 
          rule %r/\b\w+\b/ do |m|
            if self.class.keywords.include? m[0]
              token Keyword
            elsif self.class.datatypes.include? m[0]
              token Keyword::Type
            elsif self.class.functions.include? m[0]
              token Name::Function
            else
              token Name
            end
          end

          # Match operators
          rule %r/#{operators.map { |o| Regexp.escape(o) }.join('|')}/, Operator

          # Enter a state when encountering an opening curly bracket
          rule %r/{/, Punctuation::Indicator, :block

          # Match punctuation
          rule %r/#{punctuation.map { |p| Regexp.escape(p) }.join('|')}/, Punctuation

          # Match identifiers
          rule %r/[a-zA-Z_]\w*/, Name

          # Match decorators
          rule %r/@[a-zA-Z_]\w*/, Name::Decorator

          # Ignore whitespace
          rule %r/\s+/, Text
      end
      
      state :comments do
        rule %r(//[^\n\r]+), Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
      end

      state :string do
        rule %r/[^'$}]+/, Str::Single
        rule %r/\$(?!\{)/, Str::Single
        rule %r/\$[\{]/, Str::Interpol, :interp
        rule %r/\'/, Str::Single, :pop!
        rule %r/\$+/, Str::Single
      end
    
      state :interp do
        rule %r/\}/, Str::Interpol, :pop!
        mixin :root
      end

      # State for matching code blocks between curly brackets
      state :block do
        # Match property names
        rule %r/\b([a-zA-Z_]\w*)\b(?=\s*:)/, Name::Property

        # Match closing curly brackets
        rule %r/}/, Punctuation::Indicator, :pop!

        # Include the root state for nested tokens
        mixin :root
      end
    end
  end
end
