module Rouge
	module Lexers
		class Berry < RegexLexer
			title "Berry"
			desc "The Berry programming language (https://github.com/berry-lang/berry)"
			tag 'berry'
			aliases 'be'
			filenames '*.be'
			mimetypes 'text/x-berry', 'application/x-berry'

			def self.detect?(text)
				return true if text.shebang?(/berry(?:\d+(?:.\d+)?)?(?:\s*)/)
			end

			def self.constants
				@constants ||= [
          			'true', 'false', 'nil'
        		]
			end

			def self.reserved
				@reserved ||= [
          			'as', 'break', 'static', 'self', 'super'
        	]
			end

			def self.controls
				@controls ||= [
					'do', 'if', 'elif', 'else', 'for', 'while', 'break', 
          			'end', 'continue', 'return', 'try', 'except', 'raise'
        		]
			end

			def self.builtins
				@builtins ||= [
          			'assert', 'bool', 'input', 'classname', 'classof',
					'bytes', 'compile', 'map', 'list', 'int', 'isinstance', 'print',
					'range', 'str', 'super', 'module', 'size', 'issubclass', 'open',
					'file', 'type', 'call', 'number', 'real'
        		]
			end

			def processtokens(m, t)
				if self.class.reserved.include? m[0]
					token Keyword::Reserved
				elsif self.class.builtins.include? m[0]
					token Name::Builtin
				elsif self.class.controls.include? m[0]
					token Keyword
				else
					token t
				end
			end

			identifier = /\b[^\W\d]\w*\b/

			state :root do
        		# Match whitespace
				rule %r/\s+/, Text::Whitespace
        		# Match comments
				rule %r/#-(.|\n)*?-#/, Comment::Multiline
				rule %r/#(\n|[\w\W]*?\n)/, Comment::Single
        		# Match dotted identifiers / properties
				rule %r/(\.)(#{identifier})(?!\s*\()/ do
					groups Punctuation, Name::Property
				end
        		# Match import statements - import x, y, z
				rule %r/(import)(\s+)(#{identifier})/ do
					groups Keyword::Namespace, Text, Name::Namespace
					push :inlineimport
				end
        		# Match method declarations and name if not anonymous
				rule %r/(def)(\s*)(#{identifier}|(?=\s*\())/ do
					groups Keyword::Declaration, Text, Name::Function       
				end
        		# Match class declaration name and optional parent
				rule %r/(class)(\s+)(#{identifier})/ do
					groups Keyword::Declaration, Text, Name::Class
					push :inherits
				end
        		# Match keywords or function call
				rule %r/(?<!\.)#{identifier}(?=\s*\()/ do |m|
					processtokens(m, Name::Function)
				end
        		# Match keywords or default name token
				rule %r/(?<!\.)#{identifier}/ do |m|
					if self.class.constants.include? m[0]
						token Keyword::Constant
					elsif 'var' == m[0]
						token Keyword::Declaration
					else
						processtokens(m, Name)
					end
				end
        		# Safety catch all
				rule identifier, Name
        		# Match strings
				rule %r/"/, Str::Double, :doublestring
				rule %r/'/, Str::Single, :singlestring
        		# Match concat operator e.g, (3..9) or 'a' .. 'b' 
				rule %r/\.\./, Operator
        		# Match numbers. Negative lookbehind so we don't match ..
				digits = /\d+/
				decimal = /((#{digits})?\.#{digits}|#{digits}\.(?<!\.))/
				exponent = /e[+-]?#{digits}/i
				rule %r/#{decimal}(#{exponent})?/i, Num::Float
				rule %r/#{digits}#{exponent}/i, Num::Float
				rule %r/#{digits}j/i, Num::Float
				rule %r/0x([a-f0-9])+/i, Num::Hex
				rule %r/[-]?\d+/, Num::Integer
        		# Match operators and punctuation
				rule %r/[~!%^&*+=|?:<>\/-]/, Operator
				rule %r/[(){}\[\],;.]/, Punctuation
			end

      # Match escape sequences in string
      state :doublestring do
        rule %r/[^%\\"]+/, Str::Double
        rule %r/\\./, Str::Escape 
        mixin :format
        rule %r/"/, Str::Double, :pop!
      end

      # Match escape sequences in string
      state :singlestring do
        rule %r/[^%\\']+/, Str::Single
        rule %r/\\./, Str::Escape
        mixin :format
        rule %r/'/, Str::Single, :pop!
      end

      # Match format interpolation in a string
      state :format do
        rule %r/%[-+\s#]?(\0?\d+)?(\.\d+)?[doxXfeEgGcsq%]/, Str::Interpol
      end

      # Match :child
			state :inherits do 
				rule %r/(\s*)(:)(\s*)(#{identifier})/ do
					groups Text, Operator, Text, Name::Class
					pop!
				end
				rule %r/\s*/, Text::Whitespace, :pop!
			end

      # Match import a,b,c etc
			state :inlineimport do 
				rule %r/(\s*)(,)(\s*)(#{identifier})/ do
					groups Text, Punctuation, Text, Name::Namespace
					pop!
					push :inlineimport
				end
				rule %r/\s*/, Text::Whitespace, :pop!
			end
      
		end
	end
end
