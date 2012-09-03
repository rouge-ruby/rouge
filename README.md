# Rouge

This project needs your help!  There are lots of lexers to be implemented / ported / fixed, and features that need to be added or implemented.  If you'd like to help out, send me a pull request (even if it's not done yet!).  Bonus points for feature branches.

## Usage

``` ruby
# make some nice lexed html, compatible with pygments stylesheets
formatter = Rouge::Formatters::HTML.new(:css_class => '.highlight')
lexer = Rouge::Lexers::Shell.new
Rouge.highlight(File.read('/etc/bash.bashrc'), lexer, formatter)
# or
formatter.render(lexer.lex(File.read('/etc/bashrc')))

# apply a theme
Rouge::Themes::ThankfulEyes.new(:scope => '.highlight').render
```

Rouge aims to be simple to extend, and to be a drop-in replacement pygments, with the same quality of output.

### Advantages to pygments.rb
* No python bridge is necessary - you can deploy it on Heroku effortlessly, without the need for [epic hacks][].
[epic hacks]: https://github.com/rumblelabs/pygments-heroku

### Advantages to CodeRay
* The HTML output from Rouge is fully compatible with stylesheets designed for pygments.
* The lexers are implemented with a dedicated DSL, rather than being hand-coded.
