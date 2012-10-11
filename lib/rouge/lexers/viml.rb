module Rouge
  module Lexers
    class VimL < RegexLexer
      tag 'viml'
      aliases 'vim', 'vimscript', 'ex'
      filenames '*.vim', '*.vba', '.vimrc', '.exrc', '.gvimrc',
                '_vimrc', '_exrc', '_gvimrc' # _ names for windows

      mimetypes 'text/x-vim'

      def self.keywords
        load Pathname.new(__FILE__).dirname.join('viml/keywords.rb')
        self.keywords
      end

      state :root do
        rule /^(\s*)(".*?)$/ do
          group 'Text'; group 'Comment'
        end

        rule /^\s*\\/, 'Literal.String.Escape'

        rule /[ \t]+/, 'Text'

        # TODO: regexes can have other delimiters
        rule %r(/(\\\\|\\/|[^\n/])*/), 'Literal.String.Regex'
        rule %r("(\\\\|\\"|[^\n"])*"), 'Literal.String.Double'
        rule %r('(\\\\|\\'|[^\n'])*'), 'Literal.String.Single'

        # if it's not a string, it's a comment.
        rule /(?<=\s)"[^-:.%#=*].*?$/, 'Comment'

        rule /-?\d+/, 'Literal.Number'
        rule /#[0-9a-f]{6}/i, 'Literal.Number.Hex'
        rule /^:/, 'Punctuation'
        rule /[():<>+=!\[\]{}\|,~.-]/, 'Punctuation'
        rule /\b(let|if|else|endif|elseif|fun|function|endfunction)\b/,
          'Keyword'

        rule /\b(NONE|bold|italic|underline|dark|light)\b/, 'Name.Builtin'

        rule /[absg]:\w+\b/, 'Name.Variable'
        rule /\b\w+\b/, 'Postprocess.Name'

        # no errors in VimL!
        rule /./m, 'Text'
      end

      postprocess 'Postprocess.Name' do |tok, name|
        keywords = self.class.keywords

        if mapping_contains?(keywords[:command], name)
          token 'Keyword', name
        elsif mapping_contains?(keywords[:option], name)
          token 'Name.Builtin', name
        elsif mapping_contains?(keywords[:auto], name)
          token 'Name.Builtin', name
        else
          token 'Text', name
        end
      end

      def mapping_contains?(mapping, word)
        shortest, longest = find_likely_mapping(mapping, word)

        word.start_with?(shortest) and longest.start_with?(word)
      end

      # binary search through the mappings to find the one that's likely
      # to actually work.
      def find_likely_mapping(mapping, word)
        min = 0
        max = mapping.size

        until max == min
          mid = (max + min) / 2

          cmp, _ = mapping[mid]

          case word <=> cmp
          when 1
            # too low
            min = mid + 1
          when -1
            # too high
            max = mid
          when 0
            # just right, abort!
            return mapping[mid]
          end
        end

        mapping[max - 1]
      end
    end
  end
end
