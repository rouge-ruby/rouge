module Rouge
  module Lexers
    # shared states with SCSS
    # TODO: make this less nasty to do
    SASS_COMMON = proc do
      id = /[\w-]+/

      state :content_common do
        rule /@for\b/, 'Keyword', :for
        rule /@(debug|warn|if|while)/, 'Keyword', :value
        rule /(@mixin)(\s+)(#{id})/ do
          group 'Keyword'; group 'Text'; group 'Name.Function'
          push :value
        end

        rule /@extend\b/, 'Keyword', :selector

        rule /(@include)(\s+)(#{id})/ do
          group 'Keyword'; group 'Text'; group 'Name.Decorator'
          push :value
        end

        rule /@#{id}/, 'Keyword', :selector

        # $variable: assignment
        rule /([$]#{id})([ \t]*)(:)/ do
          group 'Name.Variable'; group 'Text'; group 'Punctuation'
          push :value
        end
      end

      state :value do
        mixin :end_section
        rule /[ \t]+/, 'Text'
        rule /[$]#{id}/, 'Name.Variable'
        rule /url[(]/, 'Literal.String.Other', :string_url
        rule /#{id}(?=\s*[(])/, 'Name.Function'
        rule /%#{id}/, 'Name.Decorator'

        # named literals
        rule /(true|false)\b/, 'Name.Pseudo'
        rule /(and|or|not)\b/, 'Operator.Word'

        # colors and numbers
        rule /#[a-z0-9]{1,6}/i, 'Literal.Number.Hex'
        rule /-?\d+(%|[a-z]+)?/, 'Literal.Number'
        rule /-?\d*\.\d+(%|[a-z]+)?/, 'Literal.Number.Integer'

        mixin :has_strings
        mixin :has_interp

        rule /[~^*!&%<>\|+=@:,.\/?-]+/, 'Operator'
        rule /[\[\]()]+/, 'Punctuation'
        rule %r(/[*]), 'Comment.Multiline', :inline_comment
        rule %r(//[^\n]*), 'Comment.Single'

        # identifiers
        rule(id) do |m|
          if CSS.builtins.include? m[0]
            token 'Name.Builtin'
          elsif CSS.constants.include? m[0]
            token 'Name.Constant'
          else
            token 'Name'
          end
        end
      end

      state :has_interp do
        rule /[#][{]/, 'Literal.String.Interpol', :interpolation
      end

      state :has_strings do
        rule /"/, 'Literal.String.Double', :dq
        rule /'/, 'Literal.String.Single', :sq
      end

      state :interpolation do
        rule /}/, 'Literal.String.Interpol', :pop!
        mixin :value
      end

      state :selector do
        mixin :end_section

        mixin :has_strings
        mixin :has_interp
        rule /[ \t]+/, 'Text'
        rule /:/, 'Name.Decorator', :pseudo_class
        rule /[.]/, 'Name.Class', :class
        rule /#/, 'Name.Namespace', :id
        rule /%/, 'Name.Variable', :placeholder
        rule id, 'Name.Tag'
        rule /&/, 'Keyword'
        rule /[~^*!&\[\]()<>\|+=@:;,.\/?-]/, 'Operator'
      end

      state :dq do
        rule /"/, 'Literal.String.Double', :pop!
        mixin :has_interp
        rule /(\\.|#(?![{])|[^\n"#])+/, 'Literal.String.Double'
      end

      state :sq do
        rule /'/, 'Literal.String.Single', :pop!
        mixin :has_interp
        rule /(\\.|#(?![{])|[^\n'#])+/, 'Literal.String.Single'
      end

      state :string_url do
        rule /[)]/, 'Literal.String.Other', :pop!
        rule /(\\.|#(?![{])|[^\n)#])+/, 'Literal.String.Other'
        mixin :has_interp
      end

      state :selector_piece do
        mixin :has_interp
        rule(//) { pop! }
      end

      state :pseudo_class do
        rule id, 'Name.Decorator'
        mixin :selector_piece
      end

      state :class do
        rule id, 'Name.Class'
        mixin :selector_piece
      end

      state :id do
        rule id, 'Name.Namespace'
        mixin :selector_piece
      end

      state :placeholder do
        rule id, 'Name.Variable'
        mixin :selector_piece
      end

      state :for do
        rule /(from|to|through)/, 'Operator.Word'
        mixin :value
      end

      state :attr_common do
        mixin :has_interp
        rule id do |m|
          if CSS.attributes.include? m[0]
            token 'Name.Label'
          else
            token 'Name.Attribute'
          end
        end
      end

      state :attribute do
        mixin :attr_common

        rule /([ \t]*)(:)/ do
          group 'Text'; group 'Punctuation'
          push :value
        end
      end

      state :inline_comment do
        rule /(\\#|#(?=[^\n{])|\*(?=[^\n\/])|[^\n#*])+/, 'Comment.Multiline'
        mixin :has_interp
        rule %r([*]/), 'Comment.Multiline', :pop!
      end
    end
  end
end
