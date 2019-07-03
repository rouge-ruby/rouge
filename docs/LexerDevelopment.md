<!-- 
# @title Lexer Development 
--> 
# Lexer Development

## Overview

A critical concept in the design of Rouge is the "lexer". A lexer converts
ordinary text into a series of tokens that Rouge can then process.

Rouge supports the languages it does by having a separate lexer for each
language. Lexer development is important both for fixing Rouge when syntax
isn't being highlighted properly and for adding languages that Rouge doesn't
support.

The remainder of this document explains how to develop a lexer for Rouge.

<p class="note">
  Please don't submit lexers that are largely copy-pasted from other files. 
  These submissions will be rejected.
</p>

## Getting Started

### Development Environment

To develop a lexer, you need to have set up a development environment. If you
haven't done that yet, we've got {file:docs/DevEnvironment.md a guide} that can
help.

The rest of this guide assumes that you have set up such an environment and,
importantly, that you have installed the gems on which Rouge depends to a
directory within the repository (we recommend `vendor/`).

### File Location

Rouge automatically loads lexers saved in the `lib/rouge/lexers/` directory and
so if you're submitting a new lexer, that's the right place to put it. The
filename should match the name of your lexer, with the Ruby filename extension
`.rb` appended. If the name of your language is `Example`, the lexer would be
saved as `lib/rouge/lexers/example.rb`.

### Subclassing `RegexLexer`

Your lexer needs to be a subclass of the {Rouge::Lexer} abstract class.  Most
lexers are in fact subclassed from {Rouge::RegexLexer} as the simplest way to
define the states of a lexer is to use rules consisting of regular expressions.
The remainder of this guide assumes your lexer is subclassed from
{Rouge::RegexLexer}.

## How to Structure

Basically, a lexer consists of two parts:

1. a series of properties that are usually declared at the top of the lexer;
   and
2. a collection of one or more states, each of which has one or more rules.

There are some additional features that a lexer can implement and we'll cover
those at the end.

For the remainder of this guide, we'll use [the JSON lexer][json-lexer] as an
example. The lexer is relatively simple and is for a language with which many
people will at least have some level of familiarity.

[json-lexer]:
https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/lexers/json.rb

### Lexer Properties

To be usable by Rouge, a lexer should declare a **title**, a **description**, a
**tag**, any **aliases**, associated **filenames** and associated
**mimetypes**.

#### Title

```rb
title "JSON"
```

The title of the lexer. It is declared using the {Rouge::Lexer.title} method.

Note: As a subclass of {Rouge::RegexLexer}, the JSON lexer inherits this method
(and its inherited methods) into its namespace and can call those methods
without needing to prefix each with `Rouge::Lexer`.  This is the case with all
of the property defining methods.

#### Description

```rb
desc "JavaScript Object Notation (json.org)"
```

The description of the lexer. It is declared using the {Rouge::Lexer.desc}
method.

#### Tag

```rb
tag "json"
```

The tag associated with the lexer. It is declared using the {Rouge::Lexer.tag}
method.

A tag provides a way to specify the lexer that should apply to text within a
given code block. In various flavours of Markdown, it's used after the opening
of a code block, such as in the following example:

    ```ruby
    puts "This is some Ruby"
    ```

The `ruby` tag is defined in [the Ruby lexer][ruby-lexer].

[ruby-lexer]:
https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/lexers/ruby.rb

#### Aliases

The aliases associated with a lexer. These are declared using the
{Rouge::Lexer.aliases}  method. Aliases are alternative ways that the lexer can
be identified.

The JSON lexer does not define any aliases but [the Ruby one][ruby-lexer] does.
We can see how it could be used by looking at another example in Markdown. This
time, instead of specifying the tag after the opening of the code block, we'll
use an alias instead:

    ```rb
    puts "This is still some Ruby"
    ```

#### Filenames

```rb
filenames "*.json"
```

The filename(s) associated with a lexer. These are declared using the
{Rouge::Lexer.filenames}  method.

Filenames are declared as "globs" that will match a particular pattern. A
"glob" may be merely the specific name of a file (eg. `Rakefile`) or it could
include one or more wildcards (eg. `*.json`).

#### Mimetypes

```rb
mimetypes "application/json", "application/vnd.api+json", "application/hal+json"
```

The mimetype(s) associated with a lexer. These are declared using the
{Rouge::Lexer.mimetypes} method.

### Lexer States

The other major element of a lexer is the collection of one or more states.
For lexers that subclass {Rouge::RegexLexer}, a state will consist
of one or more rules with a rule consisting of a regular expression and an
action. The action yields tokens and manipulates the _state stack_.

#### The State Stack

The state stack represents an ordered sequence of states the lexer is currently
processing. States are added and removed from the "top" of the stack. The
oldest state is on the bottom of the stack and the newest state is on the top.

The initial (and therefore bottommost) state is the `:root` state. The lexer
works by looking at the rules that are in the state that is on top of the
stack. These are tried _in order_ until a match is found. At this point, the
action defined in the rule is run, the head of the input stream is advanced
and the process is repeated with the state that is now on top of the stack.

Now that we've explained the concepts, let's look at how you actually define
these elements in your lexer.

#### States

```rb
state :root do 
  ... # do some stuff
end
```

A state is defined using the {Rouge::RegexLexer.state} method.
The method consists of the name of the state as a `Symbol` and a block
specifying the rules that Rouge will try to match as it parses the text.

#### Rules

A rule is defined using the {Rouge::RegexLexer::StateDSL#rule} method. The
`rule` method can define either "simple" rules or "complex" rules.

*Simple Rules*

```rb
rule /\s+/m, Text::Whitespace
rule /"/, Str::Double, :string
```

A simple rule takes:

1. a regular expression to match against;
2. a token to yield if the regular expression matches; and
3. an optional new state to push onto the state stack if the regular expression
   matches.

In the above example, there are two rules. The first rule yields the token
`Text::Whitespace` but does not do anything to the state stack. The second rule
yields the token `Str::Double` and adds the new state `:string` to the top of
the state stack. The text being parsed after this point will now be processed
by the rules in the `:string` state.

The following code shows the definition for this state and the rules that are
defined within it:

```rb
state :string do
  rule /[^\\"]+/, Str::Double 
  rule /\\./, Str::Escape 
  rule /"/, Str::Double, :pop!
end
```

The last rule features the "special state" `:pop!`. This is not really a state,
rather it is an instruction to the lexer to remove the current state from the
top of the state stack. In the JSON lexer, when we encounter the double
quotation mark `"` we enter into the state of being "in a string" and when we
next encounter the double quotation mark, we leave the string and return to the
previous state (in this case, the `:root` state).

*Complex Rules*

It is possible to define more complex rules for a lexer by calling `rule` with:

1. a regular expression to match against; and
2. a block to call if the regular expression matches.

The block called can take one argument, usually written as `m`, that contains
the regular expression match object.

These kind of rules allow for more fine-grained control of the state stack.
Inside a complex rule's block, it's possible to call {Rouge::RegexLexer#push},
{Rouge::RegexLexer#pop!}, {Rouge::RegexLexer#token} and
{Rouge::RegexLexer#delegate}.

You can see an example of these more complex rules in [the Ruby
lexer][ruby-lexer].

### Additional Features

While the properties and states are the minimum elements of a lexer that need
to be implemented, a lexer can include additional features.

#### Source Detection 

```rb
def self.detect?(text)
  return true if text.shebang? 'ruby'
end 
```

Rouge will attempt to guess the appropriate lexer if it is not otherwise clear.
If Rouge is unable to do this on the basis of any tag, associated filename or
associated mimetype, it will try to detect the appropriate lexer on the basis of
the text itself (the source). This is done by calling `self.detect?` on the
possible lexer (a default `self.detect?` method is defined in {Rouge::Lexer}
and simply returns `false`).

A lexer can implement its own `self.detect?` method that takes a
{Rouge::TextAnalyzer} object as a parameter. If the `self.detect?` method
returns true, the lexer will be selected as the appropriate lexer.

It is important to note that `self.detect?` should _only_ return `true` if it
is 100% sure that the language is detected. The most common ways for source
code to identify the language it's written in is with a shebang or a doctype
and Rouge provides the {Rouge::TextAnalyzer#shebang} method and the
{Rouge::TextAnalyzer#doctype} method specifically for use with `self.detect?`
to make these checks easy to perform.

For more general disambiguation between different lexers, see [Conflicting
Filename Globs][conflict-globs] below.

[conflict-globs]: #Conflicting_Filename_Globs

#### Special Words

Every programming language reserves certain words for use as identifiers that
have a special meaning in the language. To make regular expressions that search
for these words easier, many lexers will put the applicable keywords in an
array and make them available in a particular way (be it as a local variable,
an instance variable or what have you).

For performance and safety, we strongly recommend lexers use a class method:

```rb
module Rouge
  module Lexers
    class YetAnotherLanguage < RegexLexer
    ...

    def self.keywords
      @keywords ||= Set.new %w(key words used in this language)
    end

    ...
  end
end
```

These keywords can then be used like so:

```rb
rule /\w+/ do |m|
  if self.class.keywords.include?(m[0])
    token Keyword
  elsif
    token Name
  end
end
```

In some cases, you may want to interpolate your keywords into a regular
expression. **We strongly recommend you avoid doing this.** Having a large
number of rules that are searching for particular words is not as performant as
a rule with a generic pattern with a block that checks whether the pattern is a
member of a predefined set and assigns tokens, pushes new states, etc.

If you do need to use interpolation, be careful to use the `\b` anchor to avoid
inadvertently matching part of a longer word (eg. `if` matching `iff`)::

```rb
rule /\b(#{keywords.join('|')})\b/, Keyword
```

#### Startup

```rb
start do
  push :expr_start
  @heredoc_queue = []
end
```

The {Rouge::RegexLexer.start} method can take a block that will be called when
the lexer commences lexing. This provides a way to enter into a special state
"before" entering into the `:root` state (the `:root` state is still the
bottommost state in the state stack; the state pushed by `start` sits "on top"
but is the state in which the lexer begins.

Why would you want to do this? In some languages, there may be language
structures that can appear at the beginning of a file.
{Rouge::RegexLexer.start} provides a way to parse these structures without
needing a special rule in your `:root` state that has to keep track of whether
you are processing things for the first time.

### Subclassing

If a lexer is for a language that is very similar to a language with an
existing lexer, it's possible to subclass the existing lexer. See [the C++
lexer][cpp-lexer] and [the JSX lexer][jsx-lexer] for examples.

[cpp-lexer]: https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/lexers/cpp.rb
[jsx-lexer]: https://github.com/rouge-ruby/rouge/blob/master/lib/rouge/lexers/jsx.rb

### Gotchas

#### Conflicting Filename Globs

If two or more lexers define the same filename glob, this will cause an
{Rouge::Guesser::Ambiguous} error to be raised by certain guessing methods
(including the one used by the `assert_guess` method used in your spec).

The solution to this is to define a disambiguation procedure in the
{Rouge::Guessers::Disambiguation} class. Here's the procedure for the `*.pl`
filename glob as an example:

```rb
disambiguate "*.pl" do
  next Perl if contains?("my $")
  next Prolog if contains?(":-")
  next Prolog if matches?(/\A\w+(\(\w+\,\s*\w+\))*\./)
end
```

Then, in [your spec][specs], include a `:source` parameter when calling
`assert_guess`:

[specs]: #Specs

```rb
it "guesses by filename" do
  # *.pl needs source hints because it's also used by Prolog
  assert_guess :filename => "foo.pl", :source => "my $foo = 1"
end
```
## How to Test

When developing a lexer, it is important to have ways to test it. Rouge provides
support for three types of test files:

1. a **spec** that will run as part of Rouge's test suite;
2. a **demo** that will be tested as part of Rouge's test suite; and;
3. a **visual sample** of the various language constructs.

When you submit a lexer, you must also include these test files.

Before we look at how to run these tests, let's look at the files themselves. 

### Specs

A spec is a list of expectations that are tested as part of the test suite.
Rouge uses the Minitest library for defining these expectations. For more
information about Minitest, refer to [the documentation][minitest-docs].

[minitest-docs]: http://docs.seattlerb.org/minitest/

Your spec should at a minimum test how your lexer interacts with Rouge's
guessing algorithm. In particular, you should check:

* the associated filenames;
* the associated mimetypes; and
* the associated sources (if any).

Your spec must be saved to `spec/lexers/<name_of_your_lexer>_spec.rb`.

#### Filenames

```rb
it "guesses by filename" do
  assert_guess :filename => "foo.rb"
end
```

Each of the filename globs that are declared in the lexer should be tested in
the spec. [As discussed above][conflict-globs], if the associated filename glob
conflicts with a filename glob defined in another lexer, you will need to write
a disambiguation.

#### Mimetypes

```rb
it "guesses by mimetype" do
  assert_guess :mimetype => "text/x-ruby"
end
```

Each of the mimetypes that are declared in the lexer should be tested in the
spec.

#### Sources

```rb
it "guesses by source" do
  assert_guess :source => "#!/usr/local/bin/ruby"
end
```

If the lexer implements the `self.detect?` method, then each predicate that
returns true should be tested.

### Demos

The demo file is tested automatically as part of Rouge's test suite. The file
should be able to be parsed without producing any `Error` tokens.

The demo is also used on [rouge.jneen.net][hp] as the default text to display
when a lexer is chosen. It should be short (less than 20 lines if possible).

[hp]: http://rouge.jneen.net/

Your demo must be saved to `lib/rouge/demos/<name_of_your_lexer>`. Please note
that there is no file extension.

### Visual Samples

A visual sample is a file that includes a representive sample of the syntax of
your language. The sample should be long enough to reasonably demonstrate the
correct lexing of the language but does not need to offer complete coverage.
While it can be tempting to copy and paste code found online, please refrain
from doing this. If you need to copy code, indicate in a comment (using the
appropriate syntax for your lexer's language) the source of the code.  Avoid
including code that is duplicative of the other code in the sample.

If you are adding or fixing rules in the lexer, please add some examples of the
expressions that will be highlighted differently to the visual sample if
they're not already present. This greatly assists in reviewing your lexer
submission.

Your visual sample must be saved to `spec/visual/sample/<name_of_your_lexer>`.
As with the demo file, there is no file extension.

### Running the Tests

The spec and the demo can be run using the `rake` command. You can run this by
typing `bundle exec rake` at the command line. If everything works, you should
see a series of dots. If you have an error, this will appear here, too.

To see your visual sample, launch Rouge's visual test app by running `bundle
exec rackup`. You can choose your sample from the complete list by going to
<http://localhost:9292>.

## How to Submit

So you've developed a lexer (or fixed an existing one)—that's great! The basic
workflow for a lexer to be submitted is:

1. you make a pull request;
2. a maintainer reviews the lexer;
3. the maintainer suggests any changes that need to be made;
4. you make the necessary changes;
5. the maintainer accepts the request and merges in the code; and
6. the lexer is included in a future release of the Rouge gem.

Now you're on your way to fame and glory! (Maybe.)

If you haven't submitted a pull request before, GitHub has [excellent
documentation][gh-pr] that will help you get accustomed to the workflow.

[gh-pr]: https://help.github.com/en/articles/about-pull-requests

We're looking forward to seeing your code!

You can learn a lot by reading through some of the existing lexers. A good
example that's not too long is [the JSON lexer][json-lexer].

