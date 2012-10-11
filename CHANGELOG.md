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
