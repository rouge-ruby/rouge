# Rouge

[![Build Status](https://secure.travis-ci.org/rouge-ruby/rouge.svg)](https://travis-ci.org/rouge-ruby/rouge)
[![Gem Version](https://badge.fury.io/rb/rouge.svg)](https://rubygems.org/gems/rouge)

[rouge]: http://rouge.jneen.net/

[Rouge][] is a pure-ruby syntax highlighter.  It can highlight 100 different languages, and output HTML or ANSI 256-color text.  Its HTML output is compatible with stylesheets designed for [pygments][].

If you'd like to help out with this project, assign yourself something from the [issues][] page, and send me a pull request (even if it's not done yet!).  Bonus points for feature branches.

[issues]: https://github.com/rouge-ruby/rouge/issues "Help Out"
[pygments]: http://pygments.org/ "Pygments"

## Usage

First, take a look at the [pretty colors][].

[pretty colors]: http://rouge.jneen.net/

``` ruby
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

### Full options

#### Formatters

As of Rouge 2.0, you are encouraged to write your own formatter for custom formatting needs.
Builtin formatters include:

* `Rouge::Formatters::HTML.new` - will render your code with standard class names for tokens,
  with no div-wrapping or other bells or whistles.
* `Rouge::Formatters::HTMLInline.new(theme)` - will render your code with no class names, but
  instead inline the styling options into the `style=` attribute. This is good for emails and
  other systems where CSS support is minimal.
* `Rouge::Formatters::HTMLLinewise.new(formatter, class: 'line-%i')`
  This formatter will split your code into lines, each contained in its own div. The
  `class` option will be used to add a class name to the div, given the line
  number.
* `Rouge::Formatters::HTMLPygments.new(formatter, css_class='codehilite')`
  wraps the given formatter with div wrappers generally expected by stylesheets designed for
  Pygments.
* `Rouge::Formatters::HTMLTable.new(formatter, opts={})` will output an HTML table containing
  numbered lines. Options are:
    * `start_line: 1` - the number of the first line
    * `line_format: '%i'` - a `sprintf` template for the line number itself
    * `table_class: 'rouge-table'` - a CSS class for the table
    * `gutter_class: 'rouge-gutter'` - a CSS class for the gutter
    * `code_class: 'rouge-code'` - a CSS class for the code column
* `Rouge::Formatters::HTMLLegacy.new(opts={})` is a backwards-compatibility class intended
  for users of rouge 1.x, with options that were supported then. Options are:
    * `inline_theme: nil` - use an HTMLInline formatter with the given theme
    * `line_numbers: false` - use an HTMLTable formatter
    * `wrap: true` - use an HTMLPygments wrapper
    * `css_class: 'codehilite'` - a CSS class to use for the pygments wrapper
* `Rouge::Formatters::Terminal256.new(theme)`
  * `theme` must be an instnce of `Rouge::Theme`, or a `Hash` structure with `:theme` entry

#### Lexer options
##### debug: false
Print a trace of the lex on stdout

##### parent: ''
Allows you to specify which language the template is inside

#### CSS theme options
##### scope: '.highlight'
CSS selector that styles are applied to, e.g. `Rouge::Themes::MonokaiSublime.render(scope: 'code')`

Rouge aims to be simple to extend, and to be a drop-in replacement for pygments, with the same quality of output. Also, Rouge ships with a `rougify` command which allows you to easily highlight files in your terminal:

``` bash
$ rougify foo.rb
$ rougify style monokai.sublime > syntax.css
```

### Advantages to pygments.rb
* No need to [spawn Python processes](https://github.com/tmm1/pygments.rb).
* We're faster in [almost every measure](https://github.com/rouge-ruby/rouge/pull/41#issuecomment-223751572)

### Advantages to CodeRay
* The HTML output from Rouge is fully compatible with stylesheets designed for pygments.
* The lexers are implemented with a dedicated DSL, rather than being hand-coded.
* Rouge supports every language CodeRay does and more.

## You can even use it with Redcarpet

``` ruby
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # yep, that's it.
end
```

If you have `:fenced_code_blocks` enabled, you can specify languages, and even options with CGI syntax, like `php?start_inline=1`, or `erb?parent=javascript`.

## Encodings

Rouge is only for UTF-8 strings.  If you'd like to highlight a string with a different encoding, please convert it to UTF-8 first.

## Other integrations

* Middleman: [middleman-syntax](https://github.com/middleman/middleman-syntax) (@bhollis)
* Middleman: [middleman-rouge][] (@Linuus)
* RDoc: [rdoc-rouge][] (@zzak)
* Rouge::Rails: [render code samples in your rails views][rouge-rails] (@jacobsimeon)

[middleman-rouge]: https://github.com/Linuus/middleman-rouge
[rdoc-rouge]: https://github.com/zzak/rdoc-rouge
[rouge-rails]: https://github.com/jacobsimeon/rouge-rails

## Contributing

### Bug reports

Rouge uses GitHub issues to report bugs. You can [choose][issue-chooser] from one of our templates or create a custom issue. Issues that have not been active for a year are automatically closed by GitHub's [Probot][].

[issue-chooser]: https://github.com/rouge-ruby/rouge/issues/new/choose "Issue Template Chooser"
[Probot]: https://probot.github.io "GitHub's Probot"

### Installing Ruby

If you're here to implement a lexer for your awesome language, there's a good chance you don't already have a ruby development environment set up.  Follow the [instructions on the wiki](https://github.com/rouge-ruby/rouge/wiki/Setting-up-Ruby) to get up and running.  If you have trouble getting set up, let me know - I'm always happy to help.

### Run the tests

You can test the core of Rouge simply by running `rake` (no `bundle exec` required), or `rake spec TEST=spec/xxx_spec.rb`
to run a single test file.

It's also set up with `guard`, if you like.

To test a lexer visually, run `rackup` from the root and go to `localhost:9292/#{some_lexer}` where `some_lexer` is the tag or an alias of a lexer you'd like to test.  If you add `?debug=1`, helpful debugging info will be printed on stdout.

### API Documentation

is at http://rubydoc.info/gems/rouge/frames.

### Developing lexers

We have [a guide][lexer-dev-doc] on lexer development in the documentation but you'll also learn a lot by reading through the existing lexers. 

[lexer-dev-doc]: https://www.rubydoc.info/github/rouge-ruby/rouge/file/docs/LexerDevelopment.md

Please don't submit lexers that are largely copy-pasted from other files.

## Versioning

Rouge uses [Semantic Versioning 2.0.0][sv2].

[sv2]: http://semver.org/

## Tips

I don't get paid to maintain rouge. If you've found this software useful, consider dropping a tip in the [bucket](http://cash.me/$jneen).

## License

Rouge is released under the MIT license. Please see the `LICENSE` file for more information.
