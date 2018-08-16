# ChangeLog

This log summarizes the changes in each released version of rouge. The versioning scheme
we use is semver, although we will often release new lexers in minor versions, as a
practical matter.

## version 3.2.1: (2018/08/16)

https://github.com/jneen/rouge/compare/v3.2.0...v3.2.1

* Perl Lexer
  * Allow any non-whitespace character to delimit regexes ([#974](https://github.com/jneen/rouge/pull/974) by dblessing)
    * Details: In specific cases where a previously unsupported regex delimiter was
      used, a later rule could cause a backtrack in the regex system.
      This resulted in Rouge hanging for an unspecified amount of time.

## version 3.2.0: (2018/08/02)

https://github.com/jneen/rouge/compare/v3.1.1...v3.2.0

* General
  * Load pastie theme ([#809](https://github.com/jneen/rouge/pull/809) by rramsden)
  * Fix build failures ([#892](https://github.com/jneen/rouge/pull/892) by olleolleolle)
  * Update CLI style help text ([#923](https://github.com/jneen/rouge/pull/923) by nixpulvis)
  * Fix HTMLLinewise formatter documentation in README.md ([#910](https://github.com/jneen/rouge/pull/910) by rohitpaulk)
* Terraform Lexer (NEW - [#917](https://github.com/jneen/rouge/pull/917) by lowjoel)
* Crystal Lexer (NEW - [#441](https://github.com/jneen/rouge/pull/441) by splattael)
* Scheme Lexer
  * Allow square brackets ([#849](https://github.com/jneen/rouge/pull/849) by EFanZh)
* Haskell Lexer
  * Support for Quasiquotations ([#868](https://github.com/jneen/rouge/pull/868) by enolan)
* Java Lexer
  * Support for Java 10 `var` keyword ([#888](https://github.com/jneen/rouge/pull/888) by lc-soft)
* VHDL Lexer
  * Fix `time_vector` keyword typo ([#911](https://github.com/jneen/rouge/pull/911) by ttobsen)
* Perl Lexer
  * Recognize `.t` as valid file extension ([#918](https://github.com/jneen/rouge/pull/918) by miparnisari)
* Nix Lexer
  * Improved escaping sequences for indented strings ([#926](https://github.com/jneen/rouge/pull/926) by veprbl)
* Fortran Lexer
  * Recognize `.f` as valid file extension ([#931](https://github.com/jneen/rouge/pull/931) by veprbl)
* Igor Pro Lexer
  * Update functions and operations for Igor Pro 8 ([#921](https://github.com/jneen/rouge/pull/921) by t-b)
* Julia Lexer
  * Various improvements and fixes ([#912](https://github.com/jneen/rouge/pull/912) by ararslan)
* Kotlin Lexer
  * Recognize `.kts` as valid file extension ([#908](https://github.com/jneen/rouge/pull/908) by mkobit)
* CSS Lexer
  * Minor fixes ([#916](https://github.com/jneen/rouge/pull/916) by miparnisari)
* HTML Lexer
  * Minor fixes ([#916](https://github.com/jneen/rouge/pull/916) by miparnisari)
* Javascript Lexer
  * Minor fixes ([#916](https://github.com/jneen/rouge/pull/916) by miparnisari)
* Markdown Lexer
  * Images may not have alt text ([#904](https://github.com/jneen/rouge/pull/904) by Himura2la)
* ERB Lexer
  * Fix greedy comment matching ([#902](https://github.com/jneen/rouge/pull/902) by ananace)

## version 3.1.1: 2018/01/31

https://github.com/jneen/rouge/compare/v3.1.0...v3.1.1

* Perl
  * [Fix \#851: error on modulo operato in Perl by miparnisari · Pull Request \#853 · jneen/rouge](https://github.com/jneen/rouge/pull/853)
* JavaScript
  * [Detect \*\.mjs files as being JavaScript by Kovensky · Pull Request \#866 · jneen/rouge](https://github.com/jneen/rouge/pull/866)
* Swift
  [\[Swift\] Undo parsing function calls with trailing closure by dan\-zheng · Pull Request \#862 · jneen/rouge](https://github.com/jneen/rouge/pull/862)
* Vue
  * [Fix load SCSS in Vue by purecaptain · Pull Request \#842 · jneen/rouge](https://github.com/jneen/rouge/pull/842)

## version 3.1.0: 2017/12/21

Thanks a lot for contributions; not only for the code, but also for the issues and review comments, which are vitally helpful.

https://github.com/jneen/rouge/compare/v3.0.0...v3.1.0
* gemspec
  * Add source code and changelog links to gemspec [#785](https://github.com/jneen/rouge/pull/785) by @timrogers
* General
  * Fix #796: comments not followed by a newline are not highlighted [#797](https://github.com/jneen/rouge/pull/797) by @tyxchen
* Elem
  * Add Elm language support [#744](https://github.com/jneen/rouge/pull/744) by @dmitryrogozhny
* Ruby
  * Add the .erb file extension to ruby highlighting [#713](https://github.com/jneen/rouge/pull/713) by @jstumbaugh
* Hack
  * Add basic Hack support [#712](https://github.com/jneen/rouge/pull/712) by @fredemmott
* F#
  * Allow double backtick F# identifiers [#793](https://github.com/jneen/rouge/pull/793) by @nickbabcock
* Swift
  * Swift support for backticks and keypath syntax  [#794](https://github.com/jneen/rouge/pull/794) by @johnfairh
  * [Swift] Tuple destructuring, function call with lambda argument [#837](https://github.com/jneen/rouge/pull/837) by @dan-zheng
* Python
  * Add async and await keywords to Python lexer [#799](https://github.com/jneen/rouge/pull/799) by @BigChief45
* Shell
  * Add missing shell commands and missing GNU coreutils executables [#798](https://github.com/jneen/rouge/pull/798) by @kernhanda
* PowerShell
  * Add JEA file extensions to powershell [#807](https://github.com/jneen/rouge/pull/807) by @michaeltlombardi
* SASS / SCSS
  * Don't treat `[` as a part of an attribute name in SCSS [#839](https://github.com/jneen/rouge/pull/839) by @hibariya
* Haskell
  * Don't treat `error` specially in Haskell [#834](https://github.com/jneen/rouge/pull/834) by @enolan
* Rust
  * Rust: highlight the "where" keyword [#823](https://github.com/jneen/rouge/pull/823) by @lvillani

## version 3.0.0: 2017/09/21

https://github.com/jneen/rouge/compare/v2.2.1...v3.0.0

There is no breaking change in the public API, but internals' is changed.

* general:
  * dropped support for Ruby 1.9, requireing Ruby v2.0.0 (#775 by gfx)
  * [Internal API changes] refactored disaambiguators to removes the use of analyze_text's numeric score interface (#763 by jneen)
    * See https://github.com/jneen/rouge/pull/763 for details
  * added `rouge guess $file` sub-command to test guessers (#773 by gfx)
  * added `Rouge::Lexe.guess { fallback }` interface (#777 by gfx)
  * removes BOM and normalizes newlines in input sources before lexing (#776 by gfx)
* kotlin:
  * fix errors in generic functions (#782 by gfx; thanks to @rongi for reporting it)
* haskell:
  * fix escapes in char literals (#780 by gfx; thanks to @Tosainu for reporting it)

## version 2.2.1: 2017/08/22

https://github.com/jneen/rouge/compare/v2.2.0...v2.2.1

* powershell:
  * Adding PowerShell builtin commands for version 5 (#757 thanks JacodeWeerd)
* general:
  * Rouge::Guessers::Modeline#filter: reduce object allocations (#756 thanks @parkr)

## version 2.2.0: 2017-08-09

https://github.com/jneen/rouge/compare/v2.1.1...v2.2.0

* rougify:
  * trap PIPE only when platform supports it (#700 thanks @maverickwoo)
  * support null formatter (`-f tokens`) (#719 thanks @abalkin)
* kotlin:
  * update for companion object rename (#702 thanks @stkent)
* igorpro:
  * fix igorpro lexer errrors (#706 thanks @ukos-git)
* nix:
  * support nix expression language (#732 thanks @vidbina)
* q:
  * fix rules for numeric literals (#717 thanks @abalkin)
* fortran:
  * add missing Fortran keywords and intrinsics (#739 thanks @pbregener)
* javascript:
  * Fix lexer on `<` in `<script>...</script>` (#727 thanks @cpallares)
* general:
  * speed up `shebang?` check (#738 thanks @schneems)
  * don't default to a hash in Lexer.format (#729)
  * use the token's qualname in null formatter (#730)
* formatter:
  * fix "unknown formatter: terminal256" (#735 thanks @cuihq)
* gemspec:
  * fix licenses to rubygems standard (#714 thanks @nomoon)

## version 2.1.1: 2017-06-21

  * rougify: display help when called with no arguments
  * console: bugfix for line continuations dropping characters
  * make: properly handle code that doesn't end in a newline
  * fix some warnings with -w, add a rubocop configuration

## version 2.1.0: 2017-06-06

  * javascript:
    - fix for newlines in template expressions (#570 thanks @Kovensky!)
    - update keywords to ES2017 (#594 thanks @Kovensky!)
    - add ES6 binary and octal literals (#619 thanks @beaufortfrancois!)
  * ruby:
    - require an `=` on the `=end` block comment terminator
    - bugfix for numeric ranges (#579 thanks @kjcpaas!)
    - bugfix for constants following class/module declarations
  * shell: support based numbers in math mode
  * html-inline formatter:
    - now accepts a search string, an instance, or aliases for the theme argument
  * ocaml:
    - highlight variant tags
    - fixes for operators vs punctuation
    - fix polymorphic variants, support local open expressions, fix keywords
        (#643 thanks @emillon!)

  * thankful-eyes theme:
    - bold operators, to distinguish between punctuation

  * rust:
    - add support for range operators and type variables (#591 thanks @whitequark!)
    - support rustdoc hidden lines that start with # (#652 thanks @seanmonstar!)
  * html: allow template languages to interpolate within script or style tags
  * clojure:
    - finally add support for `@`
    - associate `*.edn`
  * new lexer: lasso (#584 thanks @EricFromCanada!)
  * ruby 1.9 support: Fix unescaped `@` in regex (#588 thanks @jiphex!)
  * fix comments at end of files in F# and R (#590 thanks @nickbabcock!)
  * elixir: implement ruby-style sigil strings and regexes (#530 thanks @k3rni!)
  * docker: add missing keywords
  * add ruby 2.4 support
  * coffeescript: bugfix for improper multiline comments (#604 thanks @dblessing!)
  * json: make exponent signs optional (#597 thanks @HerrFolgreich!)
  * terminal256 formatter: put reset characters at the end of each line
      (#603 thanks @deivid-rodriguez!)
  * csharp:
    - actually highlight interface names
    - highlight splice literals `$""` and `@$""` (#600 thanks @jmarianer!)
    - recognize `nameof` as a keyword (#626 thanks @drovani!)
  * new lexer: mosel (#606 thanks @germanriano!)
  * php:
    - more robust ident regex that supports unicode idents
    - add heuristics to determine whether to start inline
  * new lexer: q (kdb+) (#655 thanks @abalkin!)
  * new lexer: pony (#651 thanks @katafrakt!)
  * new lexer: igor-pro (#648 thanks @ukos-git!)
  * new lexer: wollok (#647 thanks @mumuki!)
  * new lexer: graphql (#634 thanks @hibariya!)
  * properties: allow hyphens in key names (#629 thanks @cezariuszmarek!)
  * HTMLPygments formatter: (breaking) wrap tokens with div.highlight
  * new lexer: console (replaces old `shell_session` lexer)
    - properly detects prompts and continuations
    - fully configurable prompt string with `?prompt=...`
    - optional root-level comments with `?comments`
  * new lexer: irb
  * xml: allow newlines in attribute values (#663 thanks @mojavelinux!)
  * windows fix: use `YAML.load_file` to load apache keywords
  * new lexer: dot (graphviz) (#627 thanks @kAworu)
  * overhaul options handling, and treat options as untrusted user content
  * add global opt-in to debug mode (`Rouge::Lexer.enable_debug!`) to prevent
    debug mode from being activated by users
  * shell: more strict builtins (don't highlight `cd-hello`) (#684 thanks @alex-felix!)
  * new lexer: sieve (#682 thanks @kAworu!)
  * new lexer: TSX (#669 thanks @timothykang!)
  * fortran: update to 2008 (#667 thanks @pbregener!)
  * powershell: use backtick as escape instead of backslash (#660 thanks @gmckeown!)
  * new lexer: awk (#607 thanks @kAworu)
  * new lexer: hylang (#623 thanks @profitware!)
  * new lexer: plist (#622 thanks @segiddins!)
  * groovy: support shebangs (#608 thanks @hwdegroot!)
  * new lexer: pastie (#576 thanks @mojavelinux)
  * sed: bugfix for dropped characters from regexes
  * sml:
    - bugfix for dropped keywords
    - bugfix for mishighlighted keywords
  * gherkin, php, lua, vim, matlab: update keyword files
  * new lexer: digdag (#674 thanks @gfx!)
  * json-doc: highlight bare keys
  * HTMLTable: don't output a newline after the closing tag (#659 thanks @gpakosz!)


## version 2.0.7: 2016-11-18

  * haml: fix balanced braces in attribute curlies
  * clojure:
    - allow comments at EOF
    - detect for `build.boot` (thanks @pandeiro)
  * ruby 1.9.1 compat: escape @ signs (thanks @pille1842)
  * c++
    - add `*.tpp` as an extension (thanks @vser1)
    - add more C++11 keywords
  * new lexer: ABAP (thanks @mlaggner)
  * rougify: properly handle SIGPIPE for downstream pipe closing (thanks @maverickwoo)
  * tex: add `*.sty` and `*.cls` extensions
  * html: bugfix for multiple style tags - was too greedy
  * new lexer: vue
  * perl: fix lexing of POD comments (thanks @kgoess)
  * coq: better string escape handling
  * javascript:
    - add support for ES decorators
    - fix multiline template strings with curlies (thanks @Kovensky)
  * json: stop guessing based on curlies
  * rust: support the `?` operator

## version 2.0.6: 2016-09-07

  * actionscript: emit correct tokens for positive numbers (thanks @JoeRobich!)
  * json: bottom-up rewrite, massively improve string performance
  * markdown: don't terminate code blocks unless there's a newline before the terminator
  * tulip: rewrite lexer with updated features
  * swift: update for swift 3 (thanks @radex!)
  * fortran: correctly lex exponent floats (thanks @jschwab!)
  * bugfix: escape `\@` for ruby 1.9.x
  * verilog: recognize underscores and question marks (thanks @whitequark!)
  * common lisp: recognize .asd files for ASDF
  * new lexer: mxml (thanks @JoeRobich!)
  * new lexer: 1c (thanks @karnilaev!)
  * new lexer: turtle/trig (thanks @jakubklimek!)
  * new lexer: vhdl (thanks @ttobsen!)
  * new lexer: jsx
  * new lexer: prometheus (thanks @dblessing!)

## version 2.0.5: 2016-07-19

  * bugfix: don't spam stdout from the yaml lexer

## version 2.0.4: 2016-07-19 (yanked)

  * new lexer: docker (thanks @KitaitiMakoto!)
  * new lexer: fsharp (thanks @raymens!)
  * python: improve string escapes (thanks @di!)
  * yaml: highlight keys differently than values

## version 2.0.3: 2016-07-14

  * guessing: ambiguous guesses now raise `Rouge::Guesser::Ambiguous` instead of a
    mysterious class inside a metaclass.
  * praat: various fixes for unconventional names (thanks @jjatria!)
  * workaround for rdoc parsing bug that should fix `gem install` with rdoc parsing on.
  * ruby:
    - best effort colon handling
    - fix for heredocs with method calls at the end
  * tulip: rewrite from the ground up
  * markdown: fix improper greediness of backticks
  * tooling: improve the debug output, and properly highlight the legend

## version 2.0.2: 2016-06-27

  * liquid: support variables ending in question marks (thanks @brettg!)
  * new lexer: IDL (thanks @sappjw!)
  * javascript:
    - fix bug causing `:` error tokens (#497)
    - support for ES6 string interpolation with backticks (thanks @iRath96!)
  * csharp: allow comments at EOF
  * java: allow underscored numeric literals (thanks @vandiedakaf!)
  * terminal formatter: theme changes had broken this formatter, this is fixed.
  * shell: support "ansi strings" - `$'some-string\n'`

## version 2.0.1: 2016-06-15

  * Bugfix for `Formatter#token_lines` without a block

## version 2.0.0: 2016-06-14

  * new formatters! see README.md for documentation, use `Rouge::Formatters::HTMLLegacy`
    for the old behavior.

## version 1.11.1: 2016-06-14

  * new guesser infrastructure, support for emacs and vim modelines (#489)
  * javascript bugfix for nested objects with quoted keys (#496)
  * new theme: Gruvbox (thanks @jamietanna!)
  * praat: lots of improvements (thanks @jjatria)
  * fix for rougify error when highlighting from stdin (#493)
  * new lexer: kotlin (thanks @meleyal!)
  * new lexer: cfscript (thanks @mjclemente!)

## version 1.11.0: 2016-06-06

  * groovy:
    - remove pathological regexes and add basic support for triple-quoted strings (#485)
    - add the "trait" keyword and fix project url (thanks @glaforge! #378)
  * new lexer: coq (thanks @gmalecha! #389)
  * gemspec license now more accurate (thanks @connorshea! #484)
  * swift:
    - properly support nested comments (thanks @dblessing! #479)
    - support swift 2.2 features (thanks @radex #376 and @wokalski #442)
    - add indirect declaration (thanks @nRewik! #326)
  * new lexer: verilog (thanks @Razer6! #317)
  * new lexer: typescript (thanks @Seikho! #400)
  * new lexers: jinja and twig (thanks @robin850! #402)
  * new lexer: pascal (thanks @alexcu!)
  * css: support attribute selectors (thanks @skoji! #426)
  * new lexer: shell session (thanks @sio4! #481)
  * ruby: add support for <<~ heredocs (thanks @tinci! #362)
  * recognize comments at EOF in SQL, Apache, and CMake (thanks @julp! #360)
  * new lexer: phtml (thanks @Igloczek #366)
  * recognize comments at EOF in CoffeeScript (thanks @rdavila! #370)
  * c/c++:
    - support c11/c++11 features (thanks @Tosainu! #371)
    - Allow underscores in identifiers (thanks @coverify! #333)
  * rust: add more builtin types (thanks @RalfJung! #372)
  * ini: allow hyphen keys (thanks @KrzysiekJ! #380)
  * r: massively improve lexing quality (thanks @klmr! #383)
  * c#:
    - add missing keywords (thanks @BenVlodgi #384 and @SLaks #447)
  * diff: do not require newlines at the ends (thanks @AaronLasseigne! #387)
  * new lexer: ceylon (thanks @bjansen! #414)
  * new lexer: biml (thanks @japj! #415)
  * new lexer: TAP - the test anything protocol (thanks @mblayman! #409)
  * rougify bugfix: treat input as utf8 (thanks @japj! #417)
  * new lexer: jsonnet (thanks @davidzchen! #420)
  * clojure: associate `*.cljc` for cross-platform clojure (thanks @alesguzik! #423)
  * new lexer: D (thanks @nikibobi! #435)
  * new lexer: smarty (thanks @tringenbach! #427)
  * apache:
    - add directives for v2.4 (thanks @stanhu!)
    - various improvements (thanks @julp! #301)
      - faster keyword lookups
      - fix nil error on unknown directive (cf #246, #300)
      - properly manage case-insensitive names (cf #246)
      - properly handle windows CRLF
  * objective-c:
    - support literal dictionaries and block arguments (thanks @BenV! #443 and #444)
    - Fix error tokens when defining interfaces (thanks @meleyal! #477)
  * new lexer: NASM (thanks @sraboy! #457)
  * new lexer: gradle (thanks @nerro! #468)
  * new lexer: API Blueprint (thanks @kylef! #261)
  * new lexer: ActionScript (thanks @honzabrecka! #241)
  * terminal256 formatter: stop confusing token names (thanks @julp! #367)
  * new lexer: julia (thanks @mpeteuil! #331)
  * new lexer: cmake (thanks @julp! #302)
  * new lexer: eiffel (thanks @Conaclos! #323)
  * new lexer: protobuf (thanks @fqqb! #327)
  * new lexer: fortran (thanks @CruzR! #328)
  * php: associate `*.phpt` files (thanks @Razer6!)
  * python: support `raise from` and `yield from` (thanks @mordervomubel! #324)
  * new VimL example (thanks @tpope! #315)

## version 1.10.1: 2015-09-10

  * diff: fix deleted lines which were not being highlighted (thanks @DouweM)

## version 1.10.0: 2015-09-10
  * fix warnings on files being loaded multiple times
  * swift: (thanks @radex)
    - new keywords
    - support all `@`-prefixed attributes
    - add support for `try!` and `#available(...)`
  * bugfix: Properly manage `#style_for` precedence for terminal and inline formatters (thanks @mojavelinux)
  * visual basic: recognize `*.vb` files (thanks @naotaco)
  * common-lisp:
    - add `elisp` as an alias (todo: make a real elisp lexer) (thanks @tejasbubane)
    - bugfix: fix crash on array and structure literals
  * new lexer: praat (thanks @jjatria)
  * rust: stop recognizing `*.rc` (thanks @maximd)
  * matlab: correctly highlight `'` (thanks @miicha)

## version 1.9.1: 2015-07-13

  * new lexer: powershell (thanks @aaroneg!)
  * new lexer: tulip
  * bugfix: pass opts through so lex(continue: true) retains them (thanks @stanhu!)
  * c#: bugfix: don't error on unknown states in the C# lexer
  * php: match drupal file extensions (thanks @rumpelsepp!)
  * prolog: allow camelCase atoms (thanks @mumuki!)
  * c: bugfix: was dropping text in function declarations (thanks @JonathonReinhart!)
  * groovy: bugfix: allow comments at eof without newline

## version 1.9.0: 2015-05-19

  * objc: add array literals (thanks @mehowte)
  * slim: reset ruby and html lexers, be less eager with guessing, detect html entities (thanks @elstgav)
  * js: add `yield` as a keyword (thanks @honzabrecka)
  * elixir: add alias `exs` (thanks @ismaelga)
  * json: lex object keys as `Name::Tag` (thanks @morganjbruce)
  * swift: add support for `@noescape` and `@autoclosure(escaping)` (thanks @radex)
    and make `as?` and `as!` look better
  * sass/scss: add support for `@each`, `@return`, `@media`, and `@function`
    (thanks @i-like-robots)
  * diff: make the whole thing more forgiving and less buggy (thanks @rumpelsepp)
  * c++: add arduino file mappings and also Berksfile (thanks @Razer6)
  * liquid: fix #237 which was dropping content (thanks @RadLikeWhoa)
  * json: add json-api mime type (thanks @brettchalupa)

  * new lexer: glsl (thanks @sriharshachilakapati)
  * new lexer: json-doc, which is like JSON but supports comments and ellipsis (thanks @textshell)

  * add documentation to the `--formatter` option in `rougify help` (thanks @mjbshaw)
  * new website! http://rouge.jneen.net/ (thanks @edwardloveall!)


## version 1.8.0: 2015-02-01

  * css: fix "empty range in char class" bug and improve id/class name matches (#227/#228).
    Thanks @elstgav!
  * swift: add `@objc_block` and fix eof comments (#226).  Thanks @radex!
  * new lexer: liquid (#224).  Thanks @RadLikeWhoa!
  * cli: add `-v` flag to print version (#225).  Thanks @RadLikeWhoa!
  * ruby: add `alias_method` as a builtin (#223).  Thanks @kochd!
  * more conservative guessing for R, eliminate the `.S` extension
  * new theme: molokai (#220).  Thanks @kochd!
  * allow literate haskell that doesn't end in eof
  * add human-readable "title" attribute to lexers (#215).  Thanks @edwardloveall!
  * swift: add support for preprocessor macros (#201).  Thanks @mipsitan!

## version 1.7.7: 2014-12-24

  * fix previous bad release: actually add yaml files to the gem

## version 1.7.5: 2014-12-24

  lexer fixes and tweaks:
  * javascript: fix function literals in object literals (reported by @taye)
  * css: fix for percentage values and add more units (thanks @taye)
  * ruby: highlight `require_relative` as a builtin (thanks @NARKOZ)

  new lexers:
  * nim (thanks @singularperturbation)
  * apache (thanks @iiska)

  new filetype associations:
  * highlight PKGBUILD as shell (thanks @rumpelsepp)
  * highlight Podspec files as ruby (thanks @NARKOZ)

  other:
  * lots of doc work in the README (thanks @rumpelsepp)


## version 1.7.4: 2014-11-23

  * clojure: hotfix for namespaced keywords with `::`
  * background fix: add css class to pre tag instead of code tag (#191)
  * new name in readme and license
  * new contributor code of conduct

## version 1.7.3: 2014-11-15

  * ruby: hotfix for symbols in method calling position (rubyyyyy.......)
  * http: add PATCH as a verb
  * new lexer: Dart (thanks @R1der!)
  * null formatter now prints token names and values

## version 1.7.2: 2014-10-04

  * ruby: hotfix for division with no space

## version 1.7.1: 2014-09-18

  * ruby: hotfix for the `/=` operator

## version 1.7.0: 2014-09-18

  * ruby: give up on trying to highlight capitalized builtin methods
  * swift: updates for beta 6 (thanks @radex!) (#174, #172)
  * support ASCII-8BIT encoding found on macs, as it's a subset of UTF-8 (#178)
  * redcarpet plugin [BREAKING]: change `#rouge_formatter`'s override pattern
    - it is now a method that takes a lexer and returns a formatter, instead of
      a hash of generated options. (thanks @vince-styling!)
  * java: stop erroneously highlighting keywords within words (thanks @koron!) (#177)
  * html: dash is allowed in tag names (thanks @tjgrathwell!) (#173)

## version 1.6.2: 2014-08-16

  * swift: updates for beta 5 (thanks @radex!)

## version 1.6.1: 2014-07-26

  * hotfix release for common lisp, php, objective c, and qml lexers

## version 1.6.0: 2014-07-26

  * haml: balance braces in interpolation
  * new lexer: slim (thanks @knutaldrin and @greggroth!)
  * javascript: inner tokens in regexes are now lexed, as well as improvments to
    the block / object distinction.

## version 1.5.1: 2014-07-13

  * ruby bugfixes for symbol edgecases and one-letter constants
  * utf-8 all of the things
  * update all builtins
  * rust: add `box` keyword and associated builtins

## version 1.5.0: 2014-07-11

  * new lexer: swift (thanks @totocaster!)
  * update elixir for new upstream features (thanks @splattael!)
  * ruby bugfixes:
    - add support for method calls with trailing dots
    - fix for `foo[bar] / baz` being highlighted as a regex
  * terminal256 formatter: re-style each line - some platforms reset on each line

## version 1.4.0: 2014-05-28

  * breaking: wrap code in `<pre ...><code>...</code></pre>` if `:wrap` is not overridden
    (thanks @Arcovion)
  * Allow passing a theme name as a string to `:inline_theme` (thanks @Arcovion)
  * Add `:start_line` option for html line numbers (thanks @sencer)
  * List available themes in `rougify help style`

## version 1.3.4: 2014-05-03

  * New lexers:
    - QML (thanks @seanchas116)
    - Applescript (thanks @joshhepworth)
    - Properties (thanks @pkuczynski)
  * Ruby bugfix for `{ key: /regex/ }` (#134)
  * JSON bugfix: properly highlight null (thanks @zsalzbank)
  * Implement a noop formatter for perf testing (thanks @splattael)

## version 1.3.3: 2014-03-02

  * prolog bugfix: was raising an error on some inputs (#126)
  * python bugfix: was inconsistently highlighting keywords/builtins mid-word (#127)
  * html formatter: always end output with a newline (#125)

## version 1.3.2: 2014-01-13

  * Now tested in Ruby 2.1
  * C family bugfix: allow exponential floats without decimals (`1e-2`)
  * cpp: allow single quotes as digit separators (`100'000'000`)
  * ruby: highlight `%=` as an operator in the right context

## version 1.3.1: 2013-12-23

  * fill in some lexer descriptions and add the behat alias for gherkin

## version 1.3.0: 2013-12-23

  * assorted CLI bugfixes: better error handling, CGI-style options, no loadpath munging
  * html: support multiline doctypes
  * ocaml: bugfix for OO code: allows `#` as an operator
  * inline some styles in tableized output instead of relying on the theme
  * redcarpet: add overrideable `#rouge_formatter` for custom formatting options

## version 1.2.0: 2013-11-26

  * New lexers:
    - MATLAB (thanks @adambard!)
    - Scala (thanks @sgrif!)
    - Standard ML (sml)
    - OCaml
  * Major performance overhaul, now ~2x faster (see [#114][]) (thanks @korny!)
  * Deprecate `RegexLexer#group` (internal).  Use `#groups` instead.
  * Updated PHP builtins
  * CLI now responds to `rougify --version`

[#114]: https://github.com/jneen/rouge/pull/114

## version 1.1.0: 2013-11-04

  * For tableized line numbers, the table is no longer surrounded by a `<pre>`
    tag, which is invalid HTML.  This was previously causing issues with HTML
    post-processors such as loofah.  This may break some stylesheets, as it
    changes the generated markup, but stylesheets only referring to the scope
    passed to the formatter should be unaffected.
  * New lexer: moonscript (thanks @nilnor!)
  * New theme: monokai, for real this time! (thanks @3100!)
  * Fix intermittent loading errors for good with `Lexer.load_const`, which
    closes the long-standing #66

## version 1.0.0: 2013-09-28

  * lua: encoding bugfix, and a performance tweak for string literals
  * The Big 1.0!  From now on, strict semver will apply, and new lexers and
    features will be introduced in minor releases, reserving patch releases
    for bugfixes.

## version 0.5.4: 2013-09-21

  * Cleaned up stray invalid error tokens
  * Fix C++/objc loading bug in `rougify`
  * Guessing alg tweaks: don't give up if no filename or mimetype matches
  * Rebuilt the CLI without thor (removed the thor dependency)
  * objc: Bugfix for `:forward_classname` error tokens

## version 0.5.3: 2013-09-15

  * Critical bugfixes (#98 and #99) for Ruby and Markdown. Some inputs
    would throw errors. (thanks @hrysd!)

## version 0.5.2: 2013-09-15

  * Bugfixes for C/C++
  * Major bugfix: YAML was in a broken state :\ (thanks @hrysd!)
  * Implement lexer subclassing, with `append` and `prepend`
  * new lexer: objective c (!)

## version 0.5.1: 2013-09-15

  * Fix non-default themes (thanks @tiroc!)
  * Minor lexing bugfixes in ruby

## version 0.5.0: 2013-09-02

  * [Various performance optimizations][perf-0.5]
  * javascript:
    - quoted object keys were not being highlighted correctly
    - multiline comments were not being highlighted
  * common lisp: fix commented forms
  * golang: performance bump
  * ruby: fix edge case for `def-@`
  * c: fix a pathological performance case
  * fix line number alignment on non-newline-terminated code (#91)

### Breaking API Changes in v0.5.0

  * `Rouge::Lexers::Text` renamed to `Rouge::Lexers::PlainText`
  * Tokens are now constants, rather than strings.  This only affects
    you if you've written a custom lexer, formatter, or theme.

[perf-0.5]: https://github.com/jneen/rouge/pull/41#issuecomment-23561787

## version 0.4.0: 2013-08-14

  * Add the `:inline_theme` option to `Formatters::HTML` for environments
    that don't support stylesheets (like super-old email clients)
  * Improve documentation of `Formatters::HTML` options
  * bugfix: don't include subsequent whitespace in an elixir keyword.
    In certain fonts/themes, this can cause inconsistent indentation if
    bold spaces are wider than non-bold spaces.  (thanks @splattael!)

## version 0.3.10: 2013-07-31

  * Add the `license` key in the gemspec
  * new lexer: R

## version 0.3.9: 2013-07-19

  * new lexers:
    - elixir (thanks @splattael!)
    - racket (thanks @greghendershott!)

## version 0.3.8: 2013-07-02

  * new lexers:
    - erlang! (thanks @potomak!)
    - http (with content-type based delegation)
  * bugfix: highlight true and false in JSON

## version 0.3.7: 2013-06-07

  * bugfix: Add the local lib dir to the path in ./bin/rougify
    so the internal `require` works properly.
  * php: Properly lex variables in double-quoted strings and provide the
    correct token for heredocs (thanks @hrysd!)
  * Add a `:wrap` option to the html formatter (default true) to provide
    the `<pre>` wrapper.  This allows skipping the wrapper entirely for
    postprocessing.  (thanks @cjohansen!)

## version 0.3.6: 2013-05-27

  * fixed bad release that included unfinished D and wdiff lexers :\

## version 0.3.5: 2013-05-24

  * Added a github theme (thanks @simonc!) (#75)
  * Correctly highlight ruby 1.9-style symbols and %i() syntax
    (thanks @simonc!) (#74)
  * Fixed a performance bug in the C++ lexer (#73)
    reported by @jeffgran

## version 0.3.4: 2013-05-02

  * New lexer: go (thanks @hashmal!)
  * Clojure bugfix: allow # in keywords and symbols

## version 0.3.3: 2013-04-09

  * Basic prompt support in the shell lexer
  * Add CSS3 attributes to CSS/Sass/SCSS lexers
  * Bugfix for a crash in the vim lexer

## version 0.3.2: 2013-03-11

  * Another hotfix release for the Sass/SCSS lexers, because I am being dumb

## version 0.3.1: 2013-03-11

  * Hotfix release: fix errors loading the SCSS lexer on some systems.

## version 0.3.0: 2013-03-06

  * Refactor source guessing to return fewer false positives, and
    to be better at disambiguating between filename matches (such as
    `nginx.conf` vs. `*.conf`, or `*.pl` for both prolog and perl)
  * Added `Lexer.guesses` which can return multiple or zero results for a
    guess.
  * Fix number literals in C#
  * New lexers:
    - Gherkin (cucumber)
    - Prolog (@coffeejunk)
    - LLVM (@coffeejunk)

## version 0.2.15: 2013-03-03

  * New lexer: lua (thanks, @nathany!)
  * Add extra filetypes that map to Ruby (`Capfile`, `Vagrantfile`,
    `*.ru` and `*.prawn`) (@nathany)
  * Bugfix: add demos for ini and toml
  * The `thankful_eyes` theme now colors `Literal.Date`
  * No more gigantic load list in `lib/rouge.rb`

## version 0.2.14: 2013-02-28

  * New lexers:
    - puppet
    - literate coffeescript
    - literate haskell
    - ini
    - toml (@coffeejunk)
  * clojure: `cljs` alias, and make it more visually balanced by using
    `Name` instead of `Name.Variable`.
  * Stop trying to read /etc/bash.bashrc in the specs (@coffeejunk)

## version 0.2.13: 2013-02-12

  * Highlight ClojureScipt files (`*.cljs`) as Clojure (@blom)
  * README and doc enhancements (plus an actual wiki!) (@robin850)
  * Don't open `Regexp`, especially if we're not adding anything to it.

## version 0.2.12: 2013-02-07

  * Python: bugfix for lone quotes in triple-quoted strings
  * Ruby: bugfix for `#` in `%`-delimited strings

## version 0.2.11: 2013-02-04

  * New lexer: C# (csharp)
  * rust: better macro handling
  * Python bugfix for "'" and '"' (@garybernhardt)

## version 0.2.10: 2013-01-14

  * New lexer: rust (rust-lang.org)
  * Include rouge.gemspec with the built gem
  * Update the PHP builtins

## version 0.2.9: 2012-11-28

  * New lexers: io, sed, conf, and nginx
  * fixed an error on numbers in the shell lexer
  * performance bumps for shell and ruby by prioritizing more
    common patterns
  * (@korny) Future-proofed the regexes in the Perl lexer
  * `rougify` now streams the formatted text to stdout as it's
    available instead of waiting for the lex to be done.

## version 0.2.8: 2012-10-30

  * Bugfix for tableized line numbers when the code doesn't end
    with a newline.

## version 0.2.7: 2012-10-22

  * Major performance improvements.  80% running time reduction for
    some files since v0.2.5 (thanks again @korny!)
  * Deprecated `postprocess` for performance reasons - it wasn't that
    useful in the first place.
  * The shell lexer should now recognize .bashrc, .profile and friends

## version 0.2.6: 2012-10-21
  * coffeescript: don't yield error tokens for keywords as attributes
  * add the `--scope=SELECTOR` option to `rougify style`
  * Add the `:line_numbers` option to the HTML formatter to get line
    numbers!  The styling for the line numbers is determined by
    the theme's styling for `'Generic.Lineno'`
  * Massive performance improvements by reducing calls to `option`
    and to `Regexp#source` (@korny)

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
