require 'rouge/lexers/sass/common'

module Rouge
  module Lexers
    class Scss < RegexLexer
      desc "SCSS stylesheets (sass-lang.com)"
      tag 'scss'
      filenames '*.scss'
      mimetypes 'text/x-scss'

      state :root do
        rule /\s+/, 'Text'
        rule %r(//.*?\n), 'Comment.Single'
        rule %r(/[*].*?[*]/)m, 'Comment.Multiline'
        rule /@import\b/, 'Keyword', :value

        mixin :content_common

        rule(/(?=[^;{}][;}])/) { push :attribute }
        rule(/(?=[^;{}:]+:[^a-z])/) { push :attribute }

        rule(//) { push :selector }
      end

      state :end_section do
        rule /\n/, 'Text'
        rule(/[;{}]/) { token 'Punctuation'; reset_stack }
      end

      instance_eval(&SASS_COMMON)
    end
  end
end
