# Rouge

[![Build Status](https://secure.travis-ci.org/rouge-ruby/rouge.svg)](https://travis-ci.org/rouge-ruby/rouge)
[![Gem Version](https://badge.fury.io/rb/rouge.svg)](https://rubygems.org/gems/rouge)
[![YARD Docs](http://img.shields.io/badge/yard-docs-blue.svg)](https://rouge-ruby.github.io/docs/)


[Rouge][] is a pure Ruby syntax highlighter. It can highlight over 100 different
languages, and output HTML or ANSI 256-color text. Its HTML output is
compatible with stylesheets designed for [Pygments][].

[Rouge]: http://rouge.jneen.net/ "Rouge"

[Pygments]: http://pygments.org "Pygments"

## Usage

Rouge's most common uses are as a Ruby library, as part of Jekyll and as a
command line tool.

### Library

Here's a quick example of using Rouge as you would any other regular Ruby
library:

``` ruby
require 'rouge'

# make some nice lexed html
source = File.read('/etc/bashrc')
formatter = Rouge::Formatters::HTML.new
lexer = Rouge::Lexers::Shell.new
formatter.format(lexer.lex(source))

# Get some CSS
Rouge::Themes::Base16.mode(:light).render(scope: '.highlight')
# Or use Theme#find with string input
Rouge::Theme.find('base16.light').render(scope: '.highlight')
```

### Jekyll

Rouge is Jekyll's default syntax highlighter. Out of the box, Rouge will be
used to highlight text wrapped in the `{% highlight %}` template tags. The
`{% highlight %}` tag provides minimal options: you can specify the language to
use and whether to enable line numbers or not. More information is available in
[the Jekyll docs][j-docs].

[j-docs]: https://jekyllrb.com/docs/liquid/tags/#code-snippet-highlighting
"Code snippet highlighting in the Jekyll documentation"

### Command Line

Rouge ships with a `rougify` command which allows you to easily highlight files
in your terminal:

``` shell
$ rougify foo.rb
$ rougify style monokai.sublime > syntax.css
```

## Configuration

### Formatters

Rouge comes with a number of formatters built-in but as of Rouge 2.0, you are
encouraged to write your own formatter if you need something custom.

The built-in formatters are:

* `Rouge::Formatters::HTML.new` will render your code with standard class names
  for tokens, with no div-wrapping or other bells or whistles.

* `Rouge::Formatters::HTMLInline.new(theme)` will render your code with no class
  names, but instead inline the styling options into the `style=` attribute.
  This is good for emails and other systems where CSS support is minimal.

* `Rouge::Formatters::HTMLLinewise.new(formatter, class: 'line-%i')` will split
  your code into lines, each contained in its own div. The `class` option will
  be used to add a class name to the div, given the line number.

* `Rouge::Formatters::HTMLLineTable.new(formatter, opts={})` will output an HTML
  table containing numbered lines, each contained in its own table-row. Options
  are:
    * `start_line: 1` - the number of the first row
    * `line_id: 'line-%i'` - a `sprintf` template for `id` attribute with
      current line number
    * `line_class: 'lineno'` - a CSS class for each table-row
    * `table_class: 'rouge-line-table'` - a CSS class for the table
    * `gutter_class: 'rouge-gutter'` - a CSS class for the line-number cell
    * `code_class: 'rouge-code'` - a CSS class for the code cell

* `Rouge::Formatters::HTMLPygments.new(formatter, css_class='codehilite')` wraps
  the given formatter with div wrappers generally expected by stylesheets
  designed for Pygments.

* `Rouge::Formatters::HTMLTable.new(formatter, opts={})` will output an HTML
  table containing numbered lines similar to `Rouge::Formatters::HTMLLineTable`,
  except that the table from this formatter has just a single table-row.
  Therefore, while the table is more DOM-friendly for JavaScript scripting, long
  code lines will mess with the column alignment. Options are:
    * `start_line: 1` - the number of the first line
    * `line_format: '%i'` - a `sprintf` template for the line number itself
    * `table_class: 'rouge-table'` - a CSS class for the table
    * `gutter_class: 'rouge-gutter'` - a CSS class for the gutter
    * `code_class: 'rouge-code'` - a CSS class for the code column

* `Rouge::Formatters::HTMLLegacy.new(opts={})` is a backwards-compatibility
  class intended for users of Rouge 1.x, with options that were supported then.
  Options are:
    * `inline_theme: nil` - use an HTMLInline formatter with the given theme
    * `line_numbers: false` - use an HTMLTable formatter
    * `wrap: true` - use an HTMLPygments wrapper
    * `css_class: 'codehilite'` - a CSS class to use for the Pygments wrapper

* `Rouge::Formatters::Terminal256.new(theme)` is a formatter for generating
  highlighted text for use in the terminal. `theme` must be an instance of
  `Rouge::Theme`, or a `Hash` structure with `:theme` entry.

### Lexer Options

* `debug: false` will print a trace of the lex on stdout.

* `parent: ''` allows you to specify which language the template is inside.

### CSS Options

* `scope: '.highlight'` sets the CSS selector to which styles are applied,
  e.g.:

  ``` ruby
  Rouge::Themes::MonokaiSublime.render(scope: 'code')
  ```

## Documentation

Rouge's documentation is available at [rouge-ruby.github.io/docs/][docs].

[docs]: https://rouge-ruby.github.io/docs "Rouge's official documentation"

## Requirements

### Ruby

Rouge is compatible with all versions of Ruby from 2.0.0 onwards. It has no
external dependencies.

### Encodings

Rouge only supports UTF-8 strings. If you'd like to highlight a string with a
different encoding, please convert it to UTF-8 first.

## Integrations

* Middleman:
  * [middleman-syntax][] (@bhollis)
  * [middleman-rouge][] (@Linuus)
* RDoc: [rdoc-rouge][] (@zzak)
* Rails: [Rouge::Rails][] (@jacobsimeon)

[middleman-syntax]: https://github.com/middleman/middleman-syntax
[middleman-rouge]: https://github.com/Linuus/middleman-rouge
[rdoc-rouge]: https://github.com/zzak/rdoc-rouge
[Rouge::Rails]: https://github.com/jacobsimeon/rouge-rails

## Contributing

We're always excited to welcome new contributors to Rouge. By it's nature, a
syntax highlighter relies for its success on submissions from users of the
languages being highlighted. You can help Rouge by filing bug reports or
developing new lexers.

### Bug Reports

Rouge uses GitHub's Issues to report bugs. You can [choose][issue_chooser] from
one of our templates or create a custom issue. Issues that have not been active
for a year are automatically closed by GitHub's [Probot][].

[issue_chooser]: https://github.com/rouge-ruby/rouge/issues/new/choose
"Choose an issue from the templates"

[Probot]: https://probot.github.io "Read more about GitHub's Probot"

### Developing Lexers

**NOTE**: Please don't submit lexers that are copy-pasted from other files.
These submission will be rejected and we don't want you to waste your time.

We want to make it as easy as we can for anyone to contribute a lexer to Rouge.
To help get you started, we have [a shiny new guide][lexer-dev-doc] on lexer
development in the documentation. The best place is to start there.

[lexer-dev-doc]: https://rouge-ruby.github.io/docs/file.LexerDevelopment.html
"Rouge's lexer development guide"

If you get stuck and need help, submit a pull request with what you have and
make it clear in your submission that the lexer isn't finished yet. We'll do our
best to answer any questions you have and sometimes the best way to do that is
with actual code.

### Testing Rouge

Once you've cloned the repository from GitHub, you can test the core of Rouge
simply by running `rake` (no `bundle exec` required). You can also run a single
test file by setting the `TEST` environment variable to the path of the desired
test. For example, to test just the *`ruby` lexer* (located at path
`spec/lexers/ruby_spec.rb`) simply run the following:

``` shell
$ TEST=spec/lexers/ruby_spec.rb rake
```

To test a lexer visually, run `rackup` from the top-level working directory and
you should have a web server running and ready to go. Visit
<http://localhost:9292> to see the full list of Rouge's lexers.

Once you've selected a particular lexer, you can add `?debug=1` to your URL
string to see a lot of helpful debugging info printed on stdout.

## Versioning

Rouge uses [Semantic Versioning 2.0.0][sv2].

[sv2]: http://semver.org/

## Maintainers

Rouge is largely the result of the hard work of unpaid volunteers. It was
originally developed by Jeanine Adkisson (@jneen) and is currently maintained by
Jeanine Adkisson, Drew Blessing (@dblessing), Michael Camilleri (@pyrmont) and
Goro Fuji (@gfx).

## License

Rouge is released under the MIT license. Please see the `LICENSE` file for more
information.
