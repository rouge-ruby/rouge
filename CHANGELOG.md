## version 0.2.5: 2012-10-20
  * hotfix: ship the demos with the gem.

## version 0.2.4: 2012-10-20

  * Several improvements to the javasript and scheme lexers
  * Lexer.demo, with small demos for each lexer
  * Rouge.highlight takes a string for the formatter
  * Formatter.format delegates to the instance
  * sass: Support the @extend syntax, fix new-style attributes, and
    support 3.2 placeholder syntax

## version 0.2.3: 2012-10-16

  * Fixed several postprocessing-related bugs
  * New lexers: coffeescript, sass, smalltalk, handlebars/mustache

## version 0.2.2: 2012-10-13

  * In terminal256, stop highlighting backgrounds of text-like tokens
  * Fix a bug which was breaking guessing with filenames beginning with .
  * Fix the require path for redcarpet in the README (@JustinCampbell)
  * New lexers: clojure, groovy, sass, scss
  * YAML: detect files with the %YAML directive
  * Fail fast for non-UTF-8 strings
  * Formatter#render deprecated, renamed to Formatter#format.
    To be removed in v0.3.
  * Lexer#tag delegates to the class
  * Better keyword/builtin highlighting for CSS
  * Add the `:token` option to the text lexer

## version 0.2.1: 2012-10-11

  * Began the changelog
  * Removed several unused methods and features from Lexer and RegexLexer
  * Added a lexer for SQL
  * Added a lexer for VimL, along with `rake builtins:vim`
  * Added documentation for RegexLexer, TextAnalyzer, and the formatters
  * Refactored `rake phpbuiltins` - renamed to `rake builtins:php`
  * Fixed a major bug in the Ruby lexer that prevented highlighting the
    `module` keyword.
  * Changed the default formatter for the `rougify` executable to
    `terminal256`.
  * Implemented `rougify list`, and added short descriptions to all of
    the lexers.
  * Fixed a bug in the C lexer that was yielding error tokens in case
    statements.
