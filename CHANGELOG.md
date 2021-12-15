# Changelog

This log summarizes the changes in each released version of Rouge.

Rouge follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## version 3.27.0: 2021-12-15

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.26.1...v3.27.0)

- Ceylon Lexer
  - Backtracking fix in interpolation regex ([#1773](https://github.com/rouge-ruby/rouge/pull/1773) by thewoolleyman)
- Dafny Lexer
  - Add Dafny Lexer ([#1647](https://github.com/rouge-ruby/rouge/pull/1647/) by davidcok, mschlaipfer)
- Elixir Lexer
  - Add support for HEEX templates ([#1736](https://github.com/rouge-ruby/rouge/pull/1736) by sineed
- Rust Lexer
  - Fix lexing of integers, escapes, identifiers, unicode idents, keywords and builtins, byte strings and multiline and doc comments ([#1711](https://github.com/rouge-ruby/rouge/pull/1711/commits) by thomcc)
- SQL Lexer
  - Curly brace support ([#1714](https://github.com/rouge-ruby/rouge/pull/1714) by hawkfish)
  - Add more SQL dialects in visual samples ([#1751](https://github.com/rouge-ruby/rouge/pull/1751) by tancnle)
  - Windowing keywords support ([#1754](https://github.com/rouge-ruby/rouge/pull/1754) by hawkfish)
- Swift Lexer
  - Add 5.5 keywords ([#1715](https://github.com/rouge-ruby/rouge/pull/1715) by johnfairh))
- Rouge CI
  - Migrate from Travis CI to GitHub ([#1728](https://github.com/rouge-ruby/rouge/pull/1728) by Geod24)
- Documentation
  - Full list of supported languages ([#1739](https://github.com/rouge-ruby/rouge/pull/1739) by gdubicki)
  - Various fixes and improvements ([#1741](https://github.com/rouge-ruby/rouge/pull/1741), [#1745](https://github.com/rouge-ruby/rouge/pull/1745), [#1747](https://github.com/rouge-ruby/rouge/pull/1747),
    [#1748](https://github.com/rouge-ruby/rouge/pull/1748), [#1749](https://github.com/rouge-ruby/rouge/pull/1749), [#1756](https://github.com/rouge-ruby/rouge/pull/1756) by tancnle)

## version 3.26.1: 2021-09-17

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.26.0...v3.26.1)

- CPP Lexer
  - Add year and date chrono literals, add std::complex literals, fix chrono literals with digit separator ([#1665](https://github.com/rouge-ruby/rouge/pull/1665/) by swheaton)
- Factor and GHC Core Lexer
  - Fix catastrophic backtrack ([#1690](https://github.com/rouge-ruby/rouge/pull/1690) by Ravlen)
- JSL Lexer
  - Fix single line block comments, scoped variables and functions ([#1663](https://github.com/rouge-ruby/rouge/pull/1663) by BenPH)
- YAML Lexer
  - Fix YAML key containing special character ([#1667](https://github.com/rouge-ruby/rouge/pull/1667) by tancnle)
- Fix Ruby 2.7 keyword parameter deprecation warning ([#1597](https://github.com/rouge-ruby/rouge/pull/1597) by stanhu)
- Updated README ([#1666](https://github.com/rouge-ruby/rouge/pull/1666) by dchacke)

## version 3.26.0: 2020-12-09

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.25.0...v3.26.0)

- CMake Lexer
  - Add missing CMake commands to CMake lexer ([#1630](https://github.com/rouge-ruby/rouge/pull/1630/) by gnaggnoyil)
- Crystal Lexer
  - Improve visual sample and macro support for Crystal lexer ([#1644](https://github.com/rouge-ruby/rouge/pull/1644/) by Michael Camilleri)
  - Support floor division operator in Crystal lexer ([#1639](https://github.com/rouge-ruby/rouge/pull/1639/) by Rymiel)
- JSL Lexer
  - Fix lexing of messages, nested comments, missing operators and decimals in JSL lexer ([#1638](https://github.com/rouge-ruby/rouge/pull/1638/) by Ben Peachey Higdon)
- OCL Lexer (**NEW**)
  - Add OCL lexer ([#1637](https://github.com/rouge-ruby/rouge/pull/1637/) by Gerson Sunyé)
- Python Lexer
  - Use String::Affix token for string prefixes in Python lexer ([#1635](https://github.com/rouge-ruby/rouge/pull/1635/) by Tan Le)
- ReasonML Lexer
  - Improve support for comments in ReasonML lexer ([#1641](https://github.com/rouge-ruby/rouge/pull/1641/) by Amirali Esmaeili)
- ReScript Lexer (**NEW**)
  - Add ReScript lexer ([#1633](https://github.com/rouge-ruby/rouge/pull/1633/) by Amirali Esmaeili)
- Rust Lexer
  - Add support for octal literals to Rust lexer ([#1643](https://github.com/rouge-ruby/rouge/pull/1643/) by nsfisis)

## version 3.25.0: 2020-11-11

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.24.0...v3.25.0)

- General
  - Use `Enumerator#with_index` to detect line numbers ([#1615](https://github.com/rouge-ruby/rouge/pull/1615/) by takafumi.suzuki)
- Batchfile Lexer
  - Add support for long options to Batchfile lexer ([#1626](https://github.com/rouge-ruby/rouge/pull/1626/) by Michael Camilleri)
- C++ Lexer
  - Fix binary literal digit separator in C++ lexer ([#1620](https://github.com/rouge-ruby/rouge/pull/1620/) by swheaton)
- Docker Lexer
  - Add `Dockerfile` as an alias for the Docker lexer ([#1609](https://github.com/rouge-ruby/rouge/pull/1609/) by Konnor Rogers)
- JavaScript Lexer
  - Fix template string lexing in JavaScript lexer ([#1623](https://github.com/rouge-ruby/rouge/pull/1623/) by Michael Camilleri)
- Kotlin Lexer
  - Ensure word break follows keywords in Kotlin lexer ([#1621](https://github.com/rouge-ruby/rouge/pull/1621/) by Michael Camilleri)
- Perl Lexer
  - Improve support for sigils in Perl lexer ([#1625](https://github.com/rouge-ruby/rouge/pull/1625/) by Michael Camilleri)
- PowerShell Lexer
  - Improve lexing of nested data structures in PowerShell lexer ([#1622](https://github.com/rouge-ruby/rouge/pull/1622/) by Michael Camilleri)
  - Improve handling of data structure literals in PowerShell lexer ([#1595](https://github.com/rouge-ruby/rouge/pull/1595/) by Jeanine Adkisson)
- Ruby Lexer
  - Revert empty patterns in Ruby lexer ([#1624](https://github.com/rouge-ruby/rouge/pull/1624/) by Michael Camilleri)
- Rust Lexer
  - Add continue to keywords in Rust lexer ([#1617](https://github.com/rouge-ruby/rouge/pull/1617/) by Aleksey Kladov)
- Velocity Lexer
  - Fix lexing of brackets in Velocity lexer ([#1605](https://github.com/rouge-ruby/rouge/pull/1605/) by domRowan)

## version 3.24.0: 2020-10-14

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.23.0...v3.24.0)

- General
  - Fix errors from new empty regex requirements ([#1606](https://github.com/rouge-ruby/rouge/pull/1606/) by Michael Camilleri)
  - Restrict the use of empty-matching regular expressions ([#1548](https://github.com/rouge-ruby/rouge/pull/1548/) by Jeanine Adkisson)
  - Add a CLI debug command that provides reasonable defaults ([#1593](https://github.com/rouge-ruby/rouge/pull/1593/) by Jeanine Adkisson)
  - Update documentation to use bundle config set path ([#1583](https://github.com/rouge-ruby/rouge/pull/1583/) by ComFreek)
  - Add line highlighting option ([#1426](https://github.com/rouge-ruby/rouge/pull/1426/) by Dan Allen)
  - Add Lexer#with and Lexer.lookup_fancy ([#1565](https://github.com/rouge-ruby/rouge/pull/1565/) by Jeanine Adkisson)
- Apex Lexer
  - Fix invalid use of String#casecmp in Apex lexer ([#1596](https://github.com/rouge-ruby/rouge/pull/1596/) by Jeanine Adkisson)
- E-mail Lexer (**NEW**)
  - Add e-mail lexer ([#1567](https://github.com/rouge-ruby/rouge/pull/1567/) by Steve Mokris)
- HTTP Lexer
  - Add a :content option to HTTP lexer ([#1592](https://github.com/rouge-ruby/rouge/pull/1592/) by Jeanine Adkisson)
- J Lexer (**NEW**)
  - Add J lexer ([#1584](https://github.com/rouge-ruby/rouge/pull/1584/) by unsigned-wrong-wrong-int)
- Janet Lexer
  - Improve handling of quoted forms in Janet lexer ([#1586](https://github.com/rouge-ruby/rouge/pull/1586/) by Michael Camilleri)
- JavaScript Lexer
  - Improve optional chaining in JavaScript lexer ([#1594](https://github.com/rouge-ruby/rouge/pull/1594/) by Jeanine Adkisson)
- Rust Lexer
  - Fix lexing of await in Rust lexer ([#1587](https://github.com/rouge-ruby/rouge/pull/1587/) by nsfisis)

## version 3.23.0: 2020-09-09

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.22.0...v3.23.0)

- Kotlin Lexer
  - Fix handling of ::class in Kotlin lexer ([#1572](https://github.com/rouge-ruby/rouge/pull/1572/) by Manuel Dossinger)
- PostScript Lexer (**NEW**)
  - Add PostScript lexer ([#1578](https://github.com/rouge-ruby/rouge/pull/1578/) by Liam Cooke)
- Ruby Lexer
  - Handle % like / in Ruby lexer ([#1563](https://github.com/rouge-ruby/rouge/pull/1563/) by Jeanine Adkisson)
- Rust Lexer
  - Support tuple index expressions in Rust lexer ([#1580](https://github.com/rouge-ruby/rouge/pull/1580/) by Hugo Peixoto)
  - Fix floating point separators in Rust lexer ([#1581](https://github.com/rouge-ruby/rouge/pull/1581/) by Hugo Peixoto)
- systemd Lexer (**NEW**)
  - Add systemd lexer ([#1568](https://github.com/rouge-ruby/rouge/pull/1568/) by Jean-Louis Jouannic)

## version 3.22.0: 2020-08-12

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.21.0...v3.22.0)

- PHP Lexer
  - Rewrite PHP lexer to support use statements, function declarations and type declarations ([#1489](https://github.com/rouge-ruby/rouge/pull/1489/) by Michael Camilleri)

## version 3.21.0: 2020-07-15

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.20.0...v3.21.0)

- General
  - Improve support for Unicode identifiers in various lexers ([#1537](https://github.com/rouge-ruby/rouge/pull/1537/) by Benjamin Galliot)
  - Fix YARD error when parsing LiveScript lexer ([#1541](https://github.com/rouge-ruby/rouge/pull/1541/) by Michael Camilleri)
- Batchfile Lexer
  - Allow @ before REM in Batchfile lexer ([#1545](https://github.com/rouge-ruby/rouge/pull/1545/) by Konrad Borowski)
- BrightScript Lexer (**NEW**)
  - Add BrightScript lexer ([#1544](https://github.com/rouge-ruby/rouge/pull/1544/) by domRowan)
- C++ Lexer
  - Support template parameter packs in C++ lexer ([#1555](https://github.com/rouge-ruby/rouge/pull/1555/) by Michael Camilleri)
- Docker Lexer
  - Remove docker_ file glob from Docker lexer ([#1550](https://github.com/rouge-ruby/rouge/pull/1550/) by Michael Camilleri)
- Janet Lexer (**NEW**)
  - Add Janet lexer ([#1558](https://github.com/rouge-ruby/rouge/pull/1558/) by sogaiu)
- Jinja Lexer
  - Fix nesting of raw and verbatim tags in Jinja/Twig lexers ([#1552](https://github.com/rouge-ruby/rouge/pull/1552/) by Michael Camilleri)
- Perl Lexer
  - Support fat comma in Perl lexer ([#1553](https://github.com/rouge-ruby/rouge/pull/1553/) by Michael Camilleri)
  - Fix character escaping in Perl lexer ([#1549](https://github.com/rouge-ruby/rouge/pull/1549/) by Michael Camilleri)
- PowerShell Lexer
  - Support ? in PowerShell lexer ([#1559](https://github.com/rouge-ruby/rouge/pull/1559/) by Michael Camilleri)
  - Support using grave character to escape characters in PowerShell lexer ([#1551](https://github.com/rouge-ruby/rouge/pull/1551/) by Michael Camilleri)
- Rego Lexer
  - Fix identifier matching in Rego lexer ([#1556](https://github.com/rouge-ruby/rouge/pull/1556/) by Michael Camilleri)
- Sass Lexer
  - Fix & selector matching in Sass/SCSS lexer ([#1554](https://github.com/rouge-ruby/rouge/pull/1554/) by Michael Camilleri)
- SCSS Lexer
  - Fix & selector matching in Sass/SCSS lexer ([#1554](https://github.com/rouge-ruby/rouge/pull/1554/) by Michael Camilleri)
- SSH Config Lexer (**NEW**)
  - Add SSH config lexer ([#1543](https://github.com/rouge-ruby/rouge/pull/1543/) by Chris Buckley)
- Twig Lexer
  - Fix nesting of raw and verbatim tags in Jinja/Twig lexers ([#1552](https://github.com/rouge-ruby/rouge/pull/1552/) by Michael Camilleri)

## version 3.20.0: 2020-06-10

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.19.0...v3.20.0)

- Augeas Lexer (**NEW**)
  - Add Augeas lexer ([#1521](https://github.com/rouge-ruby/rouge/pull/1521/) by Raphaël Pinson)
- BibTeX Lexer (**NEW**)
  - Add BibTeX lexer ([#1360](https://github.com/rouge-ruby/rouge/pull/1360/) by alexlihengwang)
- C++ Lexer
  - Support scope resolution operator in C++ lexer ([#1523](https://github.com/rouge-ruby/rouge/pull/1523/) by Michael Camilleri)
- Diff Lexer
  - Fix erroneous detection in Diff lexer ([#1532](https://github.com/rouge-ruby/rouge/pull/1532/) by Catalin)
- Haskell Lexer
  - Improve support for single quotes in Haskell lexer ([#1524](https://github.com/rouge-ruby/rouge/pull/1524/) by Michael Camilleri)
- HLSL Lexer (**NEW**)
  - Add HLSL lexer ([#1520](https://github.com/rouge-ruby/rouge/pull/1520/) by Mitch McClellan)
- HTML Lexer
  - Add `*.cshtml` file glob to HTML lexer ([#1522](https://github.com/rouge-ruby/rouge/pull/1522/) by Michael Camilleri)
- JavaScript Lexer
  - Fix erroneous brace matching rule in JavaScript lexer ([#1526](https://github.com/rouge-ruby/rouge/pull/1526/) by Michael Camilleri)
- JSX Lexer
  - Simplify JSX and TSX lexers ([#1492](https://github.com/rouge-ruby/rouge/pull/1492/) by Michael Camilleri)
- LiveScript Lexer (**NEW**)
  - Add LiveScript lexer ([#650](https://github.com/rouge-ruby/rouge/pull/650/) by FuriousBoar)
- OpenType Feature File Lexer
  - Add new keywords to and fix bugs in OpenType feature file lexer ([#1519](https://github.com/rouge-ruby/rouge/pull/1519/) by Zachary Quinn Scheuren)
- PowerShell Lexer
  - Fix incorrect predicate usage in PowerShell lexer ([#1536](https://github.com/rouge-ruby/rouge/pull/1536/) by Michael Camilleri)
- TSX Lexer
  - Permit use of trailing comma in generics in TSX lexer ([#1528](https://github.com/rouge-ruby/rouge/pull/1528/) by Michael Camilleri)
  - Simplify JSX and TSX lexers ([#1492](https://github.com/rouge-ruby/rouge/pull/1492/) by Michael Camilleri)
  - Change the way common methods are mixed in to TypeScript-based lexers ([#1527](https://github.com/rouge-ruby/rouge/pull/1527/) by Michael Camilleri)
- TypeScript Lexer
  - Support nullish coalescing operator in TypeScript lexer ([#1529](https://github.com/rouge-ruby/rouge/pull/1529/) by Michael Camilleri)
  - Move rules from TypeScript lexer to TypeScript common module ([#1530](https://github.com/rouge-ruby/rouge/pull/1530/) by Michael Camilleri)
  - Change the way common methods are mixed in to TypeScript-based lexers ([#1527](https://github.com/rouge-ruby/rouge/pull/1527/) by Michael Camilleri)
- Velocity Lexer (**NEW**)
  - Add Velocity lexer ([#1518](https://github.com/rouge-ruby/rouge/pull/1518/) by Michael Camilleri)
- Zig Lexer (**NEW**)
  - Add Zig lexer ([#1533](https://github.com/rouge-ruby/rouge/pull/1533/) by Timmy Jose)

## version 3.19.0: 2020-05-13

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.18.0...v3.19.0)

- General
  - Use qualified method name for calls to Kernel#load ([#1503](https://github.com/rouge-ruby/rouge/pull/1503/) by Michael Camilleri)
  - Update keyword-generation Rake tasks ([#1500](https://github.com/rouge-ruby/rouge/pull/1500/) by Michael Camilleri)
  - Add Rake task to generate keywords for LLVM lexer ([#1505](https://github.com/rouge-ruby/rouge/pull/1505/) by Michael Camilleri)
- JavaScript Lexer
  - Add CommonJS file glob to JavaScript lexer ([#1511](https://github.com/rouge-ruby/rouge/pull/1511/) by Andrew)
- Kotlin Lexer
  - Improve handling of numbers in Kotlin lexer ([#1509](https://github.com/rouge-ruby/rouge/pull/1509/) by Jen)
  - Add generic parameter keywords to Kotlin lexer ([#1504](https://github.com/rouge-ruby/rouge/pull/1504/) by Jen)
- Python Lexer
  - Fix RuboCop grouped expression warning in Python lexer ([#1513](https://github.com/rouge-ruby/rouge/pull/1513/) by Michael Camilleri)
  - Allow Unicode in Python identifiers ([#1510](https://github.com/rouge-ruby/rouge/pull/1510/) by Niko Strijbol)
  - Fix escape sequences in Python's strings ([#1508](https://github.com/rouge-ruby/rouge/pull/1508/) by Michael Camilleri)
- SPARQL Lexer
  - Support the 'a' keyword in SPARQL lexer ([#1493](https://github.com/rouge-ruby/rouge/pull/1493/) by Michael Camilleri)
- Turtle Lexer
  - Allow empty prefix in Turtle lexer ([#1494](https://github.com/rouge-ruby/rouge/pull/1494/) by Michael Camilleri)

## version 3.18.0: 2020-04-15

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.17.0...v3.18.0)

- General
  - Use plain Ruby files for built-in keyword lists ([#1418](https://github.com/rouge-ruby/rouge/pull/1418/) by Ashwin Maroli)
  - Load Rouge files using methods scoped to the Rouge module ([#1481](https://github.com/rouge-ruby/rouge/pull/1481/) by Michael Camilleri)
  - Use module constants to store directory paths for file loading ([#1416](https://github.com/rouge-ruby/rouge/pull/1416/) by Ashwin Maroli)
  - Fix Ruby keyword warning in check:memory Rake task ([#1431](https://github.com/rouge-ruby/rouge/pull/1431/) by Ashwin Maroli)
  - Revert Rubocop splat expansion cop ([#1461](https://github.com/rouge-ruby/rouge/pull/1461/) by Michael Camilleri)
- C++ Lexer
  - Make lexing of class-like identifiers more consistent in C++ lexer ([#1495](https://github.com/rouge-ruby/rouge/pull/1495/) by Michael Camilleri)
- CMake Lexer
  - Fix handling of escaped quotes in CMake lexer ([#1473](https://github.com/rouge-ruby/rouge/pull/1473/) by Michael Camilleri)
- Console Lexer
  - Add option to tokenise error messages in Console lexer ([#1498](https://github.com/rouge-ruby/rouge/pull/1498/) by Gavin Lock)
- Cypher Lexer (**NEW**)
  - Add Cypher lexer ([#1423](https://github.com/rouge-ruby/rouge/pull/1423/) by Guillaume Grossetie)
- Datastudio Lexer (**NEW**)
  - Add Datastudio lexer ([#1453](https://github.com/rouge-ruby/rouge/pull/1453/) by Bastien Durel)
- F# Lexer
  - Support dictionary indexers on nested properties in F# lexer ([#1482](https://github.com/rouge-ruby/rouge/pull/1482/) by Michael Camilleri)
- GHC Cmm Lexer (**NEW**)
  - Add GHC Cmm lexer ([#1387](https://github.com/rouge-ruby/rouge/pull/1387/) by Sven Tennie)
- ISBL Lexer (**NEW**)
  - Add ISBL lexer ([#891](https://github.com/rouge-ruby/rouge/pull/891/) by Dmitriy Tarasov)
- JSON Lexer
  - Allow unmatched braces and brackets in JSON lexer ([#1497](https://github.com/rouge-ruby/rouge/pull/1497/) by Michael Camilleri)
- JSONDOC Lexer
  - Add jsonc alias to JSONDOC lexer ([#1440](https://github.com/rouge-ruby/rouge/pull/1440/) by Michael Camilleri)
- Kotlin Lexer
  - Support labels in Kotlin lexer ([#1496](https://github.com/rouge-ruby/rouge/pull/1496/) by Jen)
- Markdown Lexer
  - Add support for multi-line links in Markdown lexer ([#1465](https://github.com/rouge-ruby/rouge/pull/1465/) by Marcel Amirault)
- Pascal Lexer
  - Add Lazarus program file glob to Pascal lexer ([#1466](https://github.com/rouge-ruby/rouge/pull/1466/) by Morabaraba)
- PHP Lexer
  - Separate ? from other operators in PHP lexer ([#1478](https://github.com/rouge-ruby/rouge/pull/1478/) by Michael Camilleri)
  - Fix bugs, and better support v7.4.0 features, in PHP lexer ([#1397](https://github.com/rouge-ruby/rouge/pull/1397/) by julp)
- Python Lexer
  - Use generic string states in Python lexer ([#1477](https://github.com/rouge-ruby/rouge/pull/1477/) by Michael Camilleri)
  - Remove . as a operator in Python lexer ([#1375](https://github.com/rouge-ruby/rouge/pull/1375/) by Andrew Nisbet)
- Racket Lexer
  - Improve support for # in Racket lexer ([#1472](https://github.com/rouge-ruby/rouge/pull/1472/) by Michael Camilleri)
- Rego Lexer (**NEW**)
  - Add Rego lexer ([#1468](https://github.com/rouge-ruby/rouge/pull/1468/) by David Ashby)
- Ruby Lexer
  - Improve lexing of ternaries that include symbols in Ruby lexer ([#1476](https://github.com/rouge-ruby/rouge/pull/1476/) by Michael Camilleri)
  - Fix tokenization of compact class names in Ruby lexer ([#1470](https://github.com/rouge-ruby/rouge/pull/1470/) by Ashwin Maroli)
- Solidity Lexer (**NEW**)
  - Add Solidity lexer ([#760](https://github.com/rouge-ruby/rouge/pull/760/) by Noel Maersk)
- Terraform Lexer
  - Support regular expressions in Terraform lexer ([#1490](https://github.com/rouge-ruby/rouge/pull/1490/) by Michael Camilleri)
- TypeScript Lexer
  - Add support for optional chaining operator to TypeScript lexer ([#1475](https://github.com/rouge-ruby/rouge/pull/1475/) by Michael Camilleri)
- Vue Lexer
  - Support slot shorthand syntax to Vue lexer ([#1483](https://github.com/rouge-ruby/rouge/pull/1483/) by Michael Camilleri)
- YANG Lexer (**NEW**)
  - Remove duplicate identity keyword in YANG Lexer ([#1499](https://github.com/rouge-ruby/rouge/pull/1499/) by GRIBOK)
  - Make default rule more permissive in YANG lexer ([#1488](https://github.com/rouge-ruby/rouge/pull/1488/) by GRIBOK)
  - Update URL in YANG visual sample ([#1474](https://github.com/rouge-ruby/rouge/pull/1474/) by GRIBOK)
  - Add YANG lexer ([#1458](https://github.com/rouge-ruby/rouge/pull/1458/) by GRIBOK)

## version 3.17.0: 2020-03-11

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.16.0...v3.17.0)

- General
  - Fix name of splat expansion Rubocop rule ([#1451](https://github.com/rouge-ruby/rouge/pull/1451/) by Hiroki Noda)
- CoffeeScript Lexer
  - Improve regex and string lexing in CoffeeScript lexer ([#1441](https://github.com/rouge-ruby/rouge/pull/1441/) by Michael Camilleri)
- ECL Lexer (**NEW**)
  - Add ECL lexer ([#1396](https://github.com/rouge-ruby/rouge/pull/1396/) by David de Hilster)
- Markdown Lexer
  - Fix brackets in links in Markdown lexer ([#1445](https://github.com/rouge-ruby/rouge/pull/1445/) by Marcel Amirault)
  - Fix fenced code blocks in Markdown lexer ([#1442](https://github.com/rouge-ruby/rouge/pull/1442/) by Michael Camilleri)
- NASM Lexer
  - Rewrite NASM lexer ([#1428](https://github.com/rouge-ruby/rouge/pull/1428/) by Michael Camilleri)
- Ruby Lexer
  - Support additional number literals in the Ruby lexer ([#1456](https://github.com/rouge-ruby/rouge/pull/1456/) by FUJI Goro)
- Scala Lexer
  - Fix symbol lexing in Scala lexer ([#1438](https://github.com/rouge-ruby/rouge/pull/1438/) by Michael Camilleri)
- Varnish Lexer
  - Add support for Fastly extensions to Varnish lexer ([#1454](https://github.com/rouge-ruby/rouge/pull/1454/) by FUJI Goro)

## version 3.16.0: 2020-02-12

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.15.0...v3.16.0)

- General
  - Update GitHub Issues settings ([#1436](https://github.com/rouge-ruby/rouge/pull/1436/) by Michael Camilleri)
  - Add information about custom HTML formatters to README ([#1415](https://github.com/rouge-ruby/rouge/pull/1415/) by Jeanine Adkisson)
  - Fix memoisation of Lexer.detectable? ([#1425](https://github.com/rouge-ruby/rouge/pull/1425/) by Ashwin Maroli)
  - Update latest Ruby checked by Travis to 2.7 ([#1422](https://github.com/rouge-ruby/rouge/pull/1422/) by Michael Camilleri)
  - Add TerminalTruecolor formatter ([#1413](https://github.com/rouge-ruby/rouge/pull/1413/) by Jeanine Adkisson)
  - Fix escaping of term codes in Terminal256 formatter  ([#1404](https://github.com/rouge-ruby/rouge/pull/1404/) by Jeanine Adkisson)
  - Fix crash in Terminal256 formatter with escaped tokens ([#1402](https://github.com/rouge-ruby/rouge/pull/1402/) by Jeanine Adkisson)
- D Lexer
  - Add __FILE_FULL_PATH__ keyword to D lexer ([#1394](https://github.com/rouge-ruby/rouge/pull/1394/) by Hiroki Noda)
- Java Lexer
  - Support Unicode identifiers in Java lexer ([#1414](https://github.com/rouge-ruby/rouge/pull/1414/) by Michael Camilleri)
  - Combine import and package rules in Java lexer ([#1389](https://github.com/rouge-ruby/rouge/pull/1389/) by Michael Camilleri)
- Lua Lexer
  - Add regex support to Lua lexer ([#1403](https://github.com/rouge-ruby/rouge/pull/1403/) by Michael Camilleri)
- NASM Lexer
  - Improve the NASM visual sample ([#1421](https://github.com/rouge-ruby/rouge/pull/1421/) by Bernardo Sulzbach)
- Objective-C Lexer
  - Add @autoreleasepool keyword to Objective-C lexer ([#1424](https://github.com/rouge-ruby/rouge/pull/1424/) by Nicolas Bouilleaud)
  - Fix Error token in common Objective-C module ([#1406](https://github.com/rouge-ruby/rouge/pull/1406/) by Masataka Pocke Kuwabara)
- PowerShell Lexer
  - Fix array access priority in PowerShell lexer ([#1429](https://github.com/rouge-ruby/rouge/pull/1429/) by Michael Camilleri)
- Rust Lexer
  - Support raw strings in Rust lexer ([#1399](https://github.com/rouge-ruby/rouge/pull/1399/) by Konrad Borowski)
  - Remove sprintf-style format parsing from Rust lexer ([#1400](https://github.com/rouge-ruby/rouge/pull/1400/) by Konrad Borowski)
- Shell Lexer
  - Support using '"' to identify heredoc delimiters in Shell lexer ([#1411](https://github.com/rouge-ruby/rouge/pull/1411/) by Michael Camilleri)
- TOML Lexer
  - Improve string syntax support in TOML lexer ([#1419](https://github.com/rouge-ruby/rouge/pull/1419/) by Jeanine Adkisson)
- TypeScript Lexer
  - Support optional props in TypeScript lexer ([#1393](https://github.com/rouge-ruby/rouge/pull/1393/) by Michael Camilleri)
- Varnish Lexer (**NEW**)
  - Add Varnish lexer ([#365](https://github.com/rouge-ruby/rouge/pull/365/) by julp)
  - Clean up Varnish lexer ([#1433](https://github.com/rouge-ruby/rouge/pull/1433/) by Michael Camilleri)

## version 3.15.0: 2020-01-15

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.14.0...v3.15.0)

- General
  - Fix parsing of 'false' as Boolean option value ([#1382](https://github.com/rouge-ruby/rouge/pull/1382/) by Michael Camilleri)
- Console Lexer
  - Fix comment parsing in Console lexer ([#1379](https://github.com/rouge-ruby/rouge/pull/1379/) by Michael Camilleri)
- FreeFEM Lexer (**NEW**)
  - Add FreeFEM lexer ([#1356](https://github.com/rouge-ruby/rouge/pull/1356/) by Simon Garnotel)
- GHC Lexer (**NEW**)
  - Add GHC Core lexer ([#1377](https://github.com/rouge-ruby/rouge/pull/1377/) by Sven Tennie)
- Jinja Lexer
  - Improve comments in Jinja lexer ([#1386](https://github.com/rouge-ruby/rouge/pull/1386/) by Rick Sherman)
  - Allow spaces after filter pipes in Jinja lexer ([#1385](https://github.com/rouge-ruby/rouge/pull/1385/) by Rick Sherman)
- LLVM Lexer
  - Add addrspacecast keyword, change keyword matching system in LLVM lexer ([#1376](https://github.com/rouge-ruby/rouge/pull/1376/) by Michael Camilleri)
- Objective-C++ Lexer (**NEW**)
  - Add Objective-C++ lexer ([#1378](https://github.com/rouge-ruby/rouge/pull/1378/) by Saagar Jha)
- Python Lexer
  - Add Starlark support to Python lexer ([#1369](https://github.com/rouge-ruby/rouge/pull/1369/) by zoidbergwill)
- Rust Lexer
  - Add division operator to Rust lexer ([#1384](https://github.com/rouge-ruby/rouge/pull/1384/) by Hugo Peixoto)
- Swift Lexer
  - Add some keyword and key-path syntax to Swift lexer ([#1332](https://github.com/rouge-ruby/rouge/pull/1332/) by Jim Dovey)

## version 3.14.0: 2019-12-11

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.13.0...v3.14.0)

- General
  - Fix lexing of comments at the EOF ([#1371](https://github.com/rouge-ruby/rouge/pull/1371/) by Maxime Kjaer)
  - Fix typo in README.md ([#1367](https://github.com/rouge-ruby/rouge/pull/1367/) by Sven Tennie)
- JSONDOC Lexer
  - Update state names in json-doc lexer ([#1364](https://github.com/rouge-ruby/rouge/pull/1364/) by Maxime Kjaer)
- Liquid Lexer
  - Add pattern for matching filenames to the Liquid lexer ([#1351](https://github.com/rouge-ruby/rouge/pull/1351/) by Eric Knibbe)
- Magik Lexer
  - Add `_finally` keyword to Magik lexer ([#1365](https://github.com/rouge-ruby/rouge/pull/1365/) by Steven Looman)
- NES Assembly Lexer (**NEW**)
  - Add NES Assembly lexer ([#1354](https://github.com/rouge-ruby/rouge/pull/1354/) by Yury Sinev)
- Slice Lexer (**NEW**)
  - Add Slice lexer ([#867](https://github.com/rouge-ruby/rouge/pull/867/) by jolkdarr)
- TOML Lexer
  - Add support for inline tables to TOML lexer ([#1359](https://github.com/rouge-ruby/rouge/pull/1359/) by Michael Camilleri)

## version 3.13.0: 2019-11-13

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.12.0...v3.13.0)

- BPF Lexer
  - Support disassembler output in BPF lexer ([#1346](https://github.com/rouge-ruby/rouge/pull/1346/) by Paul Chaignon)
- Q Lexer
  - Fix quote escaping in Q lexer ([#1355](https://github.com/rouge-ruby/rouge/pull/1355/) by AngusWilson)
- TTCN-3 Lexer (**NEW**)
  - Add TTCN-3 testing language lexer ([#1337](https://github.com/rouge-ruby/rouge/pull/1337/) by Garcia)

## version 3.12.0: 2019-10-16

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.11.1...v3.12.0)

- General
  - Handle Guesser::Ambiguous in Markdown context ([#1349](https://github.com/rouge-ruby/rouge/pull/1349/) by John Fairhurst)
  - Ensure XML lexer handles unknown DOCTYPEs ([#1348](https://github.com/rouge-ruby/rouge/pull/1348/) by John Fairhurst)
  - Remove note about GitHub Pages' version of Rouge ([#1344](https://github.com/rouge-ruby/rouge/pull/1344/) by Andrew Petz)
- Embedded Elixir Lexer
  - Add Phoenix Live View file glob to Embedded Elixir lexer ([#1347](https://github.com/rouge-ruby/rouge/pull/1347/) by Maksym Verbovyi)
- Minizinc Lexer (**NEW**)
  - Add MiniZinc lexer ([#1329](https://github.com/rouge-ruby/rouge/pull/1329/) by Abe Voelker)

## version 3.11.1: 2019-10-02

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.11.0...v3.11.1)

- Perl Lexer
  - Fix overeager quoting constructs in Perl lexer ([#1335](https://github.com/rouge-ruby/rouge/pull/1335/) by Brent Laabs)

## version 3.11.0: 2019-09-18

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.10.0...v3.11.0)

- Apex Lexer (**NEW**)
  - Add Apex lexer ([#1103](https://github.com/rouge-ruby/rouge/pull/1103/) by Jefersson Nathan)
- Coq Lexer
  - Tokenise commonly used logical symbols in Coq lexer
- CSV Schema Lexer (**NEW**)
  - Add CSV Schema lexer ([#1039](https://github.com/rouge-ruby/rouge/pull/1039/) by Filipe Garcia)
- JSON Lexer
  - Fix pattern for values incorporating backslashes in JSON lexer ([#1331](https://github.com/rouge-ruby/rouge/pull/1331/) by Michael Camilleri)
- Kotlin Lexer
  - Improve support for Gradle plugin names in Kotlin lexer ([#1323](https://github.com/rouge-ruby/rouge/pull/1323/) by Andrew Lord)
  - Simplify regular expressions used in Kotlin lexer ([#1326](https://github.com/rouge-ruby/rouge/pull/1326/) by Andrew Lord)
  - Highlight constructors/functions in Kotlin lexer ([#1321](https://github.com/rouge-ruby/rouge/pull/1321/) by Andrew Lord)
  - Fix type highlighting (including nested generics) in Kotlin lexer ([#1322](https://github.com/rouge-ruby/rouge/pull/1322/) by Andrew Lord)
- Liquid Lexer
  - Rewrite large portion of Liquid lexer ([#1327](https://github.com/rouge-ruby/rouge/pull/1327/) by Eric Knibbe)
- Robot Framework Lexer (**NEW**)
  - Add Robot Framework lexer ([#611](https://github.com/rouge-ruby/rouge/pull/611/) by Iakov Gan)
- Shell Lexer
  - Add MIME types and file globs to Shell lexer ([#716](https://github.com/rouge-ruby/rouge/pull/716/) by Jan Chren)
- Swift Lexer
  - Improve attribute formatting in Swift lexer ([#806](https://github.com/rouge-ruby/rouge/pull/806/) by John Fairhurst)

## version 3.10.0: 2019-09-04

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.9.0...v3.10.0)

- General
  - Remove link to online dingus ([#1317](https://github.com/rouge-ruby/rouge/pull/1317/) by Michael Camilleri)
- Clean Lexer (**NEW**)
  - Add Clean lexer ([#1305](https://github.com/rouge-ruby/rouge/pull/1305/) by Camil Staps)
- Common Lisp Lexer
  - Add 'lisp' alias to Common Lisp lexer ([#1315](https://github.com/rouge-ruby/rouge/pull/1315/) by Bonnie Eisenman)
- HTTP Lexer
  - Permit an empty reason-phrase element in HTTP lexer ([#1313](https://github.com/rouge-ruby/rouge/pull/1313/) by Michael Camilleri)
- JSL Lexer (**NEW**)
  - Add JSL lexer ([#871](https://github.com/rouge-ruby/rouge/pull/871/) by justinc11)
- Lustre Lexer(**NEW**)
  - Correct minor errors in the Lustre lexer ([#1316](https://github.com/rouge-ruby/rouge/pull/1316/) by Michael Camilleri)
  - Add Lustre lexer ([#905](https://github.com/rouge-ruby/rouge/pull/905/) by Erwan Jahier)
- Lutin Lexer(**NEW**)
  - Add Lutin lexer ([#1307](https://github.com/rouge-ruby/rouge/pull/1307/) by Erwan Jahier)
- SPARQL Lexer (**NEW**)
  - Add SPARQL lexer ([#872](https://github.com/rouge-ruby/rouge/pull/872/) by Stefan Daschek)

## version 3.9.0: 2019-08-21

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.8.0...v3.9.0)

- EEX Lexer (**NEW**)
  - Add EEX lexer ([#874](https://github.com/rouge-ruby/rouge/pull/874/) by julp)
- Elixir Lexer
  - Fix escaping/interpolating in string and charlist literals in Elixir lexer ([#1308](https://github.com/rouge-ruby/rouge/pull/1308/) by Michael Camilleri)
- Haxe Lexer (**NEW**)
  - Add Haxe lexer ([#815](https://github.com/rouge-ruby/rouge/pull/815/) by Josu Igoa)
- HQL Lexer (**NEW**)
  - Add HQL lexer and add types to SQL lexer ([#880](https://github.com/rouge-ruby/rouge/pull/880/) by tkluck-booking)
- HTTP Lexer
  - Add support for HTTP/2 to HTTP lexer ([#1296](https://github.com/rouge-ruby/rouge/pull/1296/) by Michael Camilleri)
- JavaScript Lexer
  - Add new regex flags to JavaScript lexer ([#875](https://github.com/rouge-ruby/rouge/pull/875/) by Brad)
- MATLAB Lexer
  - Change method of saving MatLab built-in keywords ([#1300](https://github.com/rouge-ruby/rouge/pull/1300/) by Michael Camilleri)
- Q Lexer
  - Fix use of preceding whitespace in comments in Q lexer ([#858](https://github.com/rouge-ruby/rouge/pull/858/) by Mark)
- SQL Lexer
  - Add HQL lexer and add types to SQL lexer ([#880](https://github.com/rouge-ruby/rouge/pull/880/) by tkluck-booking)
- Terraform Lexer
  - Add support for first-class expressions to Terraform lexer ([#1303](https://github.com/rouge-ruby/rouge/pull/1303/) by Michael Camilleri)

## version 3.8.0: 2019-08-07

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.7.0...v3.8.0)

- General
  - Update README ([#1271](https://github.com/rouge-ruby/rouge/pull/1271/) by Michael Camilleri)
  - Disable selection in HTML generated by HTMLLineTable formatter ([#1276](https://github.com/rouge-ruby/rouge/pull/1276/) by Ashwin Maroli)
  - Remove sudo: false configuration from Travis settings ([#1281](https://github.com/rouge-ruby/rouge/pull/1281/) by Olle Jonsson)
  - Improve escaping of TeX formatter ([#1277](https://github.com/rouge-ruby/rouge/pull/1277/) by Jeanine Adkisson)
  - Change Generic::Output in Magritte theme ([#1278](https://github.com/rouge-ruby/rouge/pull/1278/) by Jeanine Adkisson)
  - Add a Rake task to check warnings output by Ruby ([#1272](https://github.com/rouge-ruby/rouge/pull/1272/) by Michael Camilleri)
  - Move to self-hosted documentation ([#1270](https://github.com/rouge-ruby/rouge/pull/1270/) by Michael Camilleri)
- ARM Assembly Lexer (**NEW**)
  - Fix preprocessor tokens in ARM Assembly lexer ([#1289](https://github.com/rouge-ruby/rouge/pull/1289/) by Michael Camilleri)
  - Add ARM assembly lexer ([#1057](https://github.com/rouge-ruby/rouge/pull/1057/) by bavison)
- Batchfile Lexer (**NEW**)
  - Add Batchfile lexer ([#1286](https://github.com/rouge-ruby/rouge/pull/1286/) by Carlos Montiers A)
- BBC Basic Lexer (**NEW**)
  - Add BBC Basic lexer ([#1280](https://github.com/rouge-ruby/rouge/pull/1280/) by bavison)
- C++ Lexer
  - Add syntax to C++ lexer ([#565](https://github.com/rouge-ruby/rouge/pull/565/) by Loo Rong Jie)
  - Add disambiguation for C++ header files ([#1269](https://github.com/rouge-ruby/rouge/pull/1269/) by Michael Camilleri)
- CMHG Lexer (**NEW**)
  - Add CMHG lexer ([#1282](https://github.com/rouge-ruby/rouge/pull/1282/) by bavison)
- Console Lexer
  - Use Text::Whitespace token in Console lexer ([#894](https://github.com/rouge-ruby/rouge/pull/894/) by Alexander Weiss)
- Cython Lexer (**NEW**)
  - Add Cython lexer ([#1287](https://github.com/rouge-ruby/rouge/pull/1287/) by Mark Waddoups)
- EPP Lexer (**NEW**)
  - Add EPP lexer ([#903](https://github.com/rouge-ruby/rouge/pull/903/) by Alexander "Ananace" Olofsson)
- JSON Lexer
  - Fix escape quoting in JSON lexer ([#1297](https://github.com/rouge-ruby/rouge/pull/1297/) by Michael Camilleri)
- Julia Lexer
  - Fix duplicating capture groups in Julia lexer ([#1292](https://github.com/rouge-ruby/rouge/pull/1292/) by Michael Camilleri)
- Make Lexer
  - Improve Make lexer ([#1285](https://github.com/rouge-ruby/rouge/pull/1285/) by bavison)
- MessageTrans Lexer (**NEW**)
  - Add a MessageTrans lexer ([#1283](https://github.com/rouge-ruby/rouge/pull/1283/) by bavison)
- Plist Lexer
  - Simplify Plist demo and visual sample ([#1275](https://github.com/rouge-ruby/rouge/pull/1275/) by Jeanine Adkisson)
- Puppet Lexer
  - Fix unmatched characters in Puppet lexer ([#1288](https://github.com/rouge-ruby/rouge/pull/1288/) by Michael Camilleri)
- R Lexer
  - Fix lexing of names in R lexer ([#896](https://github.com/rouge-ruby/rouge/pull/896/) by François Michonneau)
- sed Lexer
  - Fix custom delimiter rule in sed lexer ([#893](https://github.com/rouge-ruby/rouge/pull/893/) by Valentin Vălciu)

## version 3.7.0: 2019-07-24

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.6.0...v3.7.0)

- General
  - Rationalise Rake tasks ([#1267](https://github.com/rouge-ruby/rouge/pull/1267/) by Michael Camilleri)
  - Remove italics from preprocessor style rules ([#1264](https://github.com/rouge-ruby/rouge/pull/1264/) by Michael Camilleri)
  - Remove rubyforge_project property from gemspec ([#1263](https://github.com/rouge-ruby/rouge/pull/1263/) by Olle Jonsson)
  - Add missing magic comments ([#1258](https://github.com/rouge-ruby/rouge/pull/1258/) by Ashwin Maroli)
  - Replace tabs with spaces in some lexers ([#1257](https://github.com/rouge-ruby/rouge/pull/1257/) by Ashwin Maroli)
  - Profile memory usage of Rouge::Lexer.find_fancy ([#1256](https://github.com/rouge-ruby/rouge/pull/1256/) by Ashwin Maroli)
  - Add juxtaposing support to visual test app ([#1168](https://github.com/rouge-ruby/rouge/pull/1168/) by Ashwin Maroli)
- Ada Lexer (**NEW**)
  - Add Ada lexer ([#1255](https://github.com/rouge-ruby/rouge/pull/1255/) by Jakob Stoklund Olesen)
- CUDA Lexer (**NEW**)
  - Add CUDA lexer ([#963](https://github.com/rouge-ruby/rouge/pull/963/) by Yuma Hiramatsu)
- GDScript Lexer (**NEW**)
  - Add GDScript lexer ([#1036](https://github.com/rouge-ruby/rouge/pull/1036/) by Leonid Boykov)
- Gherkin Lexer
  - Fix placeholder lexing in Gherkin lexer ([#952](https://github.com/rouge-ruby/rouge/pull/952/) by Jamis Buck)
- GraphQL Lexer
  - Add keywords and improve frontmatter lexing in GraphQL lexer ([#1261](https://github.com/rouge-ruby/rouge/pull/1261/) by Emile Bosch)
- Handlebars Lexer
  - Fix Handlebars lexing with HTML attributes and whitespace ([#899](https://github.com/rouge-ruby/rouge/pull/899/) by Jasper Maes)
- HOCON Lexer (**NEW**)
  - Add HOCON lexer ([#1253](https://github.com/rouge-ruby/rouge/pull/1253/) by David Wood)
- HTML Lexer
  - Add support for Angular-style attributes to HTML lexer ([#907](https://github.com/rouge-ruby/rouge/pull/907/) by Runinho)
  - Simplify HTML visual sample ([#1265](https://github.com/rouge-ruby/rouge/pull/1265/) by Michael Camilleri)
- JSON Lexer
  - Add key/value highlighting to JSON lexer ([#1029](https://github.com/rouge-ruby/rouge/pull/1029/) by María Inés Parnisari)
- Mason Lexer (**NEW**)
  - Remove mistaken keywords in Mason lexer ([#1268](https://github.com/rouge-ruby/rouge/pull/1268/) by Michael Camilleri)
  - Add Mason lexer ([#838](https://github.com/rouge-ruby/rouge/pull/838/) by María Inés Parnisari)
- OpenType Feature File Lexer (**NEW**)
  - Add OpenType Feature File lexer ([#864](https://github.com/rouge-ruby/rouge/pull/864/) by Thom Janssen)
- PHP Lexer
  - Update keywords and fix comment bug in PHP lexer ([#973](https://github.com/rouge-ruby/rouge/pull/973/) by Fred Cox)
- ReasonML Lexer (**NEW**)
  - Add ReasonML lexer ([#1248](https://github.com/rouge-ruby/rouge/pull/1248/) by Sergei Azarkin)
- Rust Lexer
  - Fix lexing of attributes and doc comments in Rust lexer ([#957](https://github.com/rouge-ruby/rouge/pull/957/) by djrenren)
  - Add async & await keywords to Rust lexer ([#1259](https://github.com/rouge-ruby/rouge/pull/1259/) by Edward Andrews-Hodgson)
- SAS Lexer (**NEW**)
  - Add SAS lexer ([#1107](https://github.com/rouge-ruby/rouge/pull/1107/) by tomsutch)

## version 3.6.0: 2019-07-10

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.5.1...v3.6.0)

* General
  - Add HTMLLineTable formatter ([#1211](https://github.com/rouge-ruby/rouge/pull/1211/) by Ashwin Maroli)
  - Avoid unnecessary String duplication in HTML formatter ([#1244](https://github.com/rouge-ruby/rouge/pull/1244/) by Ashwin Maroli)
  - Remove trailing whitespace ([#1245](https://github.com/rouge-ruby/rouge/pull/1245/) by Ashwin Maroli)
  - Avoid allocating block parameters unnecessarily ([#1246](https://github.com/rouge-ruby/rouge/pull/1246/) by Ashwin Maroli)
  - Update profile_memory task ([#1243](https://github.com/rouge-ruby/rouge/pull/1243/) by Ashwin Maroli)
  - Clarify instructions for running a single test ([#1238](https://github.com/rouge-ruby/rouge/pull/1238/) by Ashwin Maroli)
  - Configure Bundler to validate task dependencies ([#1242](https://github.com/rouge-ruby/rouge/pull/1242/) by Ashwin Maroli)
  - Improve readability of lexer debug output ([#1240](https://github.com/rouge-ruby/rouge/pull/1240/) by Ashwin Maroli)
  - Add documentation on using Docker for development ([#1214](https://github.com/rouge-ruby/rouge/pull/1214/) by Nicolas Guillaumin)
  - Add ability to evaluate lexer similarity ([#1206](https://github.com/rouge-ruby/rouge/pull/1206/) by Jeanine Adkisson)
  - Fix empty color bug in TeX rendering ([#1224](https://github.com/rouge-ruby/rouge/pull/1224/) by Jeanine Adkisson)
  - Add a global 'require' option for rougify CLI tool  ([#1215](https://github.com/rouge-ruby/rouge/pull/1215/) by Jeanine Adkisson)
  - Add background colour for monokai.sublime theme ([#1204](https://github.com/rouge-ruby/rouge/pull/1204/) by Ashwin Maroli)
* Elixir Lexer
  - Improve tokenising of numbers in Elixir lexer ([#1225](https://github.com/rouge-ruby/rouge/pull/1225/) by Michael Camilleri)
* JSON Lexer
  - Add Pipfile filename globs to JSON and TOML lexers ([#975](https://github.com/rouge-ruby/rouge/pull/975/) by Remco Haszing)
* Liquid Lexer
  - Improve highlighting of for tags in Liquid lexer ([#1196](https://github.com/rouge-ruby/rouge/pull/1196/) by Ashwin Maroli)
* Make Lexer
  - Simplify Make visual sample ([#1227](https://github.com/rouge-ruby/rouge/pull/1227/) by Michael Camilleri)
* Magik Lexer
  - Add `_class` and `_while` keywords to Magik lexer ([#1251](https://github.com/rouge-ruby/rouge/pull/1251/) by Steven Looman)
* OpenEdge ABL Lexer (**NEW**)
  - Add OpenEdge ABL lexer ([#1200](https://github.com/rouge-ruby/rouge/pull/1200/) by Michael Camilleri)
* Perl Lexer
  - Add improvements (eg. transliteration) to Perl lexer ([#1250](https://github.com/rouge-ruby/rouge/pull/1250/) by Brent Laabs)
* PowerShell Lexer
  - Fix file paths in PowerShell lexer ([#1232](https://github.com/rouge-ruby/rouge/pull/1232/) by Michael Camilleri)
  - Reimplement PowerShell lexer ([#1213](https://github.com/rouge-ruby/rouge/pull/1213/) by Aaron)
* Ruby Lexer
  - Fix tokenizing of `defined?` in Ruby lexer ([#1247](https://github.com/rouge-ruby/rouge/pull/1247/) by Ashwin Maroli)
  - Add Fastlane filename globs to Ruby lexer ([#976](https://github.com/rouge-ruby/rouge/pull/976/) by Remco Haszing)
* TOML Lexer
  - Add Pipfile filename globs to JSON and TOML lexers ([#975](https://github.com/rouge-ruby/rouge/pull/975/) by Remco Haszing)
* XPath Lexer (**NEW**)
  - Add XPath and XQuery lexers ([#1089](https://github.com/rouge-ruby/rouge/pull/1089/) by Maxime Kjaer)
* XQuery Lexer (**NEW**)
  - Add XPath and XQuery lexers ([#1089](https://github.com/rouge-ruby/rouge/pull/1089/) by Maxime Kjaer)
* Xojo Lexer
  - Improve comment support in Xojo lexer ([#1229](https://github.com/rouge-ruby/rouge/pull/1229/) by Jim McKay)
* YAML Lexer
  - Fix tokenization of block strings in YAML lexer ([#1235](https://github.com/rouge-ruby/rouge/pull/1235/) by Ashwin Maroli)
  - Fix block chomping syntax in YAML lexer ([#1234](https://github.com/rouge-ruby/rouge/pull/1234/) by Ashwin Maroli)
  - Fix tokenization of number literals in YAML lexer ([#1239](https://github.com/rouge-ruby/rouge/pull/1239/) by Ashwin Maroli)

## version 3.5.1: 2019-06-26

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.5.0...v3.5.1)

* PowerShell Lexer
  - Fix invalid parenthesis state in PowerShell lexer ([#1222](https://github.com/rouge-ruby/rouge/pull/1222/) by Michael Camilleri)

## version 3.5.0: 2019-06-26

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.4.1...v3.5.0)

* General
  - Correct typo in lexer development guide ([#1219](https://github.com/rouge-ruby/rouge/pull/1219/) by Michael Camilleri)
  - Add support for TeX rendering ([#1183](https://github.com/rouge-ruby/rouge/pull/1183/) by Jeanine Adkisson)
  - Fix deprecation of argument to Lexer.continue ([#1187](https://github.com/rouge-ruby/rouge/pull/1187/) by Jeanine Adkisson)
  - Add development environment documentation ([#1212](https://github.com/rouge-ruby/rouge/pull/1212/) by Michael Camilleri)
  - Correct lexer development guide ([#1145](https://github.com/rouge-ruby/rouge/pull/1145/) by Michael Camilleri)
  - Remove unnecessary variables and fix duplicate ranges ([#1197](https://github.com/rouge-ruby/rouge/pull/1197/) by Masataka Pocke Kuwabara)
  - Optimise creation of directory names ([#1207](https://github.com/rouge-ruby/rouge/pull/1207/) by Ashwin Maroli)
  - Add reference to semantic versioning to README ([#1205](https://github.com/rouge-ruby/rouge/pull/1205/) by Michael Camilleri)
  - Add pr-open to Probot's exempt labels ([#1203](https://github.com/rouge-ruby/rouge/pull/1203/) by Michael Camilleri)
  - Adjust wording of stale issue message ([#1202](https://github.com/rouge-ruby/rouge/pull/1202/) by Michael Camilleri)
  - Configure Probot to close stale issues ([#1199](https://github.com/rouge-ruby/rouge/pull/1199/) by Michael Camilleri)
  - Add theme switcher to visual test app ([#1198](https://github.com/rouge-ruby/rouge/pull/1198/) by Ashwin Maroli)
  - Add the magritte theme ([#1182](https://github.com/rouge-ruby/rouge/pull/1182/) by Jeanine Adkisson)
  - Reduce duplicated range warnings ([#1189](https://github.com/rouge-ruby/rouge/pull/1189/) by Ashwin Maroli)
  - Improve display of visual samples ([#1181](https://github.com/rouge-ruby/rouge/pull/1181/) by Ashwin Maroli)
  - Remove duplicate issue templates ([#1193](https://github.com/rouge-ruby/rouge/pull/1193/) by Michael Camilleri)
  - Add issue templates ([#1190](https://github.com/rouge-ruby/rouge/pull/1190/) by Michael Camilleri)
  - Enable Rubocop ambiguity warnings ([#1180](https://github.com/rouge-ruby/rouge/pull/1180/) by Michael Camilleri)
  - Allow Rake tasks to be run with warnings ([#1177](https://github.com/rouge-ruby/rouge/pull/1177/) by Ashwin Maroli)
  - Reset instance variable only if it is defined ([#1184](https://github.com/rouge-ruby/rouge/pull/1184/) by Ashwin Maroli)
  - Fix `escape_enabled?` predicate method ([#1174](https://github.com/rouge-ruby/rouge/pull/1174/) by Dan Allen)
  - Fix removal of `@debug_enabled` ([#1173](https://github.com/rouge-ruby/rouge/pull/1173/) by Dan Allen)
  - Fix wording and indentation in changelog Rake task ([#1171](https://github.com/rouge-ruby/rouge/pull/1171/) by Michael Camilleri)
* BPF Lexer (**NEW**)
  - Add BPF lexer ([#1191](https://github.com/rouge-ruby/rouge/pull/1191/) by Paul Chaignon)
* Brainfuck Lexer (**NEW**)
  - Add Brainfuck lexer ([#1037](https://github.com/rouge-ruby/rouge/pull/1037/) by Andrea Esposito)
* Haskell Lexer
  - Support promoted data constructors in Haskell lexer ([#1027](https://github.com/rouge-ruby/rouge/pull/1027/) by Ben Gamari)
  - Add `*.hs-boot` glob to Haskell lexer ([#1060](https://github.com/rouge-ruby/rouge/pull/1060/) by Ben Gamari)
* JSON Lexer
  - Add extra mimetypes to JSON lexer ([#1030](https://github.com/rouge-ruby/rouge/pull/1030/) by duncangodwin)
* Jsonnet Lexer
  - Add `*.libsonnet` glob to Jsonnet lexer ([#972](https://github.com/rouge-ruby/rouge/pull/972/) by Tomas Virgl)
* Liquid Lexer
  - Fix debug errors in Liquid lexer ([#1192](https://github.com/rouge-ruby/rouge/pull/1192/) by Michael Camilleri)
* LLVM Lexer
  - Fix various issues in LLVM lexer ([#986](https://github.com/rouge-ruby/rouge/pull/986/) by Robin Dupret)
* Magik Lexer (**NEW**)
  - Add (Smallworld) Magik lexer ([#1044](https://github.com/rouge-ruby/rouge/pull/1044/) by Steven Looman)
* Prolog Lexer
  - Fix comment character in Prolog lexer ([#830](https://github.com/rouge-ruby/rouge/pull/830/) by Darius Foo)
* Python Lexer
  - Fix shebang regex in Python lexer ([#1172](https://github.com/rouge-ruby/rouge/pull/1172/) by Michael Camilleri)
* Rust Lexer
  - Add support for integer literal separators in Rust lexer ([#984](https://github.com/rouge-ruby/rouge/pull/984/) by Linda_pp)
* Shell Lexer
  - Fix interpolation and escaped backslash bugs in Shell lexer ([#1216](https://github.com/rouge-ruby/rouge/pull/1216/) by Jeanine Adkisson)
* Swift Lexer
  - Fix Swift lexer to support Swift 4.2 ([#1035](https://github.com/rouge-ruby/rouge/pull/1035/) by Mattt)

## version 3.4.1: 2019-06-13

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.4.0...v3.4.1)

* General
  - Restore support for opts to Lexer.lex ([#1178](https://github.com/rouge-ruby/rouge/pull/1178/) by Michael Camilleri)
  - Use predefined string in `bool_option` ([#1159](https://github.com/rouge-ruby/rouge/pull/1159/) by Ashwin Maroli)
  - Expand list of files ignored by Git ([#1157](https://github.com/rouge-ruby/rouge/pull/1157/) by Michael Camilleri)

## version 3.4.0: 2019-06-12

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.3.0...v3.4.0).

* General
  - Add Rake task for generating changelog entries ([#1167](https://github.com/rouge-ruby/rouge/pull/1167/) by Michael Camilleri)
  - Tidy up changelog ([#1169](https://github.com/rouge-ruby/rouge/pull/1169/) by Michael Camilleri)
  - Improve functionality of HTMLLinewise formatter ([#1156](https://github.com/rouge-ruby/rouge/pull/1156/) by Dan Allen)
  - Avoid creating array on every `Lexer.all` call ([#1140](https://github.com/rouge-ruby/rouge/pull/1140/) by Ashwin Maroli)
  - Add clearer tests for `Lexer.detectable?` ([#1153](https://github.com/rouge-ruby/rouge/pull/1153/) by Ashwin Maroli)
  - Replace the `:continue` option with a `#continue_lex` method ([#1151](https://github.com/rouge-ruby/rouge/pull/1151/) by Jeanine Adkisson)
  - Introduce `:detectable?` singleton method for lexers ([#1149](https://github.com/rouge-ruby/rouge/pull/1149/) by Ashwin Maroli)
  - Update HTMLTable formatter to delegate to inner formatter ([#1083](https://github.com/rouge-ruby/rouge/pull/1083/) by Dan Allen)
  - Add basic memory usage profile ([#1137](https://github.com/rouge-ruby/rouge/pull/1137/) by Ashwin Maroli)
  - Avoid array creation when checking if source is UTF-8 ([#1141](https://github.com/rouge-ruby/rouge/pull/1141/) by Ashwin Maroli)
  - Add lexer development documentation ([#1111](https://github.com/rouge-ruby/rouge/pull/1111/) by Michael Camilleri)
  - Coerce state names into symbols rather than strings ([#1138](https://github.com/rouge-ruby/rouge/pull/1138/) by Ashwin Maroli)
  - Configure YARD to document protected code ([#1133](https://github.com/rouge-ruby/rouge/pull/1133/) by Michael Camilleri)
  - Add missing tokens from Pygments 2.2.0 ([#1034](https://github.com/rouge-ruby/rouge/pull/1034/) by Leonid Boykov)
  - Fix undefined instance variable warning in lexer ([#1087](https://github.com/rouge-ruby/rouge/pull/1087/) by Dan Allen)
  - Port black and white style from Pygments ([#1086](https://github.com/rouge-ruby/rouge/pull/1086/) by Dan Allen)
  - Reduce allocations from just loading the gem ([#1104](https://github.com/rouge-ruby/rouge/pull/1104/) by Ashwin Maroli)
  - Update Travis to check Ruby 2.6 ([#1128](https://github.com/rouge-ruby/rouge/pull/1128/) by Michael Camilleri)
  - Update GitHub URL in README ([#1127](https://github.com/rouge-ruby/rouge/pull/1127/) by Dan Allen)
  - Remove bundler from the Gemfile ([#1110](https://github.com/rouge-ruby/rouge/pull/1110/) by Dan Allen)
* C / C++ Lexers
  - Fix various issues with highlighting in C and C++ lexers ([#1069](https://github.com/rouge-ruby/rouge/pull/1069/) by Vidar Hokstad)
* C# Lexer
  - Fix rendering of C# attributes ([#1117](https://github.com/rouge-ruby/rouge/pull/1117/) by Michael Camilleri)
* CoffeeScript Lexer
  - Add operators, keywords and reserved words to CoffeeScript lexer ([#1061](https://github.com/rouge-ruby/rouge/pull/1061/) by Erik Demaine)
  - Fix comments in CoffeeScript lexer ([#1123](https://github.com/rouge-ruby/rouge/pull/1123/) by Michael Camilleri)
* Common Lisp Lexer
  - Fix unbalanced parenthesis crash in Common Lisp lexer ([#1129](https://github.com/rouge-ruby/rouge/pull/1129/) by Michael Camilleri)
* Coq Lexer
  - Fix string parsing in Coq lexer ([#1116](https://github.com/rouge-ruby/rouge/pull/1116/) by Michael Camilleri)
* Diff Lexer
  - Add support for non-unified diffs to Diff lexer ([#1068](https://github.com/rouge-ruby/rouge/pull/1068/) by Vidar Hokstad)
* Docker Lexer
  - Add filename extensions to Docker lexer ([#1059](https://github.com/rouge-ruby/rouge/pull/1059/) by webmaster777)
* Escape Lexer (**NEW**)
  - Add escaping within lexed content ([#1152](https://github.com/rouge-ruby/rouge/pull/1152/) by Jeanine Adkisson)
* Go Lexer
  - Fix whitespace tokenisation in Go lexer ([#1122](https://github.com/rouge-ruby/rouge/pull/1122/) by Michael Camilleri)
* GraphQL Lexer
  - Add support for Markdown descriptions ([#1012](https://github.com/rouge-ruby/rouge/pull/1012) by Drew Blessing)
  - Add support for multiline strings ([#1012](https://github.com/rouge-ruby/rouge/pull/1012) by Drew Blessing)
* Java Lexer
  - Improve specificity of tokens in Java lexer ([#1124](https://github.com/rouge-ruby/rouge/pull/1124/) by Michael Camilleri)
* JavaScript Lexer
  - Fix escaping backslashes in Javascript lexer ([#1165](https://github.com/rouge-ruby/rouge/pull/1165/) by Ashwin Maroli)
  - Update keywords in JavaScript lexer ([#1126](https://github.com/rouge-ruby/rouge/pull/1126/) by Masa-Shin)
* Jinja / Twig Lexers
  - Add support for raw/verbatim blocks in Jinja/Twig lexers ([#1003](https://github.com/rouge-ruby/rouge/pull/1003/) by Robin Dupret)
  - Add `=` to Jinja operators ([#1011](https://github.com/rouge-ruby/rouge/pull/1011/) by Drew Blessing)
* Julia Lexer
  - Recognize more Julia types and constants ([#1024](https://github.com/rouge-ruby/rouge/pull/1024/) by Alex Arslan)
* Kotlin Lexer
  - Add suspend keyword to Kotlin lexer ([#1055](https://github.com/rouge-ruby/rouge/pull/1055/) by Ing. Jan Kaláb)
  - Fix nested block comments in Kotlin lexer ([#1121](https://github.com/rouge-ruby/rouge/pull/1121/) by Michael Camilleri)
* Markdown Lexer
  - Fix code blocks in Markdown lexer ([#1053](https://github.com/rouge-ruby/rouge/pull/1053/) by Vidar Hokstad)
* Matlab Lexer
  - Add Matlab2017a strings to Matlab lexer ([#1048](https://github.com/rouge-ruby/rouge/pull/1048/) by Benjamin Buch)
* Objective-C Lexer
  - Fix untyped methods ([#1118](https://github.com/rouge-ruby/rouge/pull/1118/) by Michael Camilleri)
* Perl Lexer
  - Rationalise visual sample for Perl ([#1162](https://github.com/rouge-ruby/rouge/pull/1162/) by Michael Camilleri)
  - Fix backtracking issues, add string interpolation in Perl lexer ([#1161](https://github.com/rouge-ruby/rouge/pull/1161/) by Michael Camilleri)
  - Fix arbitrary delimiter regular expressions in Perl lexer ([#1160](https://github.com/rouge-ruby/rouge/pull/1160/) by Michael Camilleri)
* Plist Lexer
  - Restore support for highlighting XML-encoded plists ([#1026](https://github.com/rouge-ruby/rouge/pull/1026/) by Dan Mendoza)
* PowerShell Lexer
  - Add 'microsoftshell' and 'msshell' as aliases for PowerShell lexer ([#1077](https://github.com/rouge-ruby/rouge/pull/1077/) by Robin Schneider)
* Rust Lexer
  - Fix escape sequences in Rust lexer ([#1120](https://github.com/rouge-ruby/rouge/pull/1120/) by Michael Camilleri)
* Scala Lexer
  - Output more differentiated tokens in Scala lexer ([#1040](https://github.com/rouge-ruby/rouge/pull/1040/) by Alan Thomas)
* Shell Lexer
  - Add APKBUILD filename glob to Shell lexer ([#1099](https://github.com/rouge-ruby/rouge/pull/1099/) by Oliver Smith)
* Slim Lexer
  - Fix multiline Ruby code in Slim lexer ([#1130](https://github.com/rouge-ruby/rouge/pull/1130/) by René Klačan)
* SuperCollider Lexer (**NEW**)
  - Add SuperCollider lexer ([#749](https://github.com/rouge-ruby/rouge/pull/749/) by Brian Heim)
* XML Lexer
  - Fix `<html>` tag breaking detection of XML files ([#1031](https://github.com/rouge-ruby/rouge/pull/1031/) by María Inés Parnisari)
* Xojo Lexer (**NEW**)
  - Add Xojo lexer ([#1131](https://github.com/rouge-ruby/rouge/pull/1131/) by Jim McKay)

## version 3.3.0: 2018-10-01

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.2.1...v3.3.0)

> **Release Highlight**: Due to #883 with the introduction of frozen string literals,
  Rouge memory usage and total objects dropped quite dramatically. See
  [#883](https://github.com/rouge-ruby/rouge/pull/883) for more details. Thanks @ashmaroli
  for this PR.

* General
  * Add frozen_string_literal ([#883](https://github.com/rouge-ruby/rouge/pull/883) ashmaroli)
* Mathematica Lexer (NEW)
  * Support for Mathematic/Wolfram ([#854](https://github.com/rouge-ruby/rouge/pull/854) by halirutan)
* Motorola 68k Lexer (NEW)
  * Add m68k assembly lexer ([#909](https://github.com/rouge-ruby/rouge/pull/909) by nguillaumin)
* SQF Lexer (NEW)
  * Add SQF Lexer ([#761](https://github.com/rouge-ruby/rouge/pull/761) by BaerMitUmlaut)
  * Minor changes to SQF ([#970](https://github.com/rouge-ruby/rouge/pull/970) by dblessing)
* JSP Lexer (NEW)
  * Add Java Server Pages lexer ([#915](https://github.com/rouge-ruby/rouge/pull/915) by miparnisari)
* Elixir Lexer
  * Add `defstruct` and `defguardp` ([#960](https://github.com/rouge-ruby/rouge/pull/960) by bjfish)
* F# / FSharp Lexer
  * Add `.fsi` extension ([#1002](https://github.com/rouge-ruby/rouge/pull/1002) by adam-becker)
* Kotlin Lexer
  * Recognise annotations and map to decorator ([#995](https://github.com/rouge-ruby/rouge/pull/995) by lordcodes)
  * Function names ([#996](https://github.com/rouge-ruby/rouge/pull/996) by lordcodes)
  * Recognizing function parameters and return type ([#999](https://github.com/rouge-ruby/rouge/pull/999) by lordcodes)
  * Recognize destructuring assignment ([#1001](https://github.com/rouge-ruby/rouge/pull/1001) by lordcodes)
* Objective-C Lexer
  * Add `objectivec` as tag/alias ([#951](https://github.com/rouge-ruby/rouge/pull/951) by revolter)
* Prolog Lexer
  * Add % as single-line comment ([#898](https://github.com/rouge-ruby/rouge/pull/898) by jamesnvc)
* Puppet Lexer
  * Add = as Operator in Puppet lexer ([#980](https://github.com/rouge-ruby/rouge/pull/980) by alexharv074)
* Python Lexer
  * Improve #-style comments ([#959](https://github.com/rouge-ruby/rouge/pull/959) by 1orenz0)
  * Improvements for builtins, literals and operators ([#940](https://github.com/rouge-ruby/rouge/pull/940) by aldanor)
* Ruby Lexer
  * Add `Dangerfile` as Ruby filename ([#1004](https://github.com/rouge-ruby/rouge/pull/1004) by leipert)
* Rust Lexer
  * Add additional aliases for Rust ([#988](https://github.com/rouge-ruby/rouge/pull/988) by LegNeato)
* Swift Lexer
  * Add `convenience` method ([#950](https://github.com/rouge-ruby/rouge/pull/950) by damian-rzeszot)

## version 3.2.1: 2018-08-16

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.2.0...v3.2.1)

* Perl Lexer
  * Allow any non-whitespace character to delimit regexes ([#974](https://github.com/rouge-ruby/rouge/pull/974) by dblessing)
    * Details: In specific cases where a previously unsupported regex delimiter was
      used, a later rule could cause a backtrack in the regex system.
      This resulted in Rouge hanging for an unspecified amount of time.

## version 3.2.0: 2018-08-02

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.1.1...v3.2.0)

* General
  * Load pastie theme ([#809](https://github.com/rouge-ruby/rouge/pull/809) by rramsden)
  * Fix build failures ([#892](https://github.com/rouge-ruby/rouge/pull/892) by olleolleolle)
  * Update CLI style help text ([#923](https://github.com/rouge-ruby/rouge/pull/923) by nixpulvis)
  * Fix HTMLLinewise formatter documentation in README.md ([#910](https://github.com/rouge-ruby/rouge/pull/910) by rohitpaulk)
* Terraform Lexer (NEW - [#917](https://github.com/rouge-ruby/rouge/pull/917) by lowjoel)
* Crystal Lexer (NEW - [#441](https://github.com/rouge-ruby/rouge/pull/441) by splattael)
* Scheme Lexer
  * Allow square brackets ([#849](https://github.com/rouge-ruby/rouge/pull/849) by EFanZh)
* Haskell Lexer
  * Support for Quasiquotations ([#868](https://github.com/rouge-ruby/rouge/pull/868) by enolan)
* Java Lexer
  * Support for Java 10 `var` keyword ([#888](https://github.com/rouge-ruby/rouge/pull/888) by lc-soft)
* VHDL Lexer
  * Fix `time_vector` keyword typo ([#911](https://github.com/rouge-ruby/rouge/pull/911) by ttobsen)
* Perl Lexer
  * Recognize `.t` as valid file extension ([#918](https://github.com/rouge-ruby/rouge/pull/918) by miparnisari)
* Nix Lexer
  * Improved escaping sequences for indented strings ([#926](https://github.com/rouge-ruby/rouge/pull/926) by veprbl)
* Fortran Lexer
  * Recognize `.f` as valid file extension ([#931](https://github.com/rouge-ruby/rouge/pull/931) by veprbl)
* Igor Pro Lexer
  * Update functions and operations for Igor Pro 8 ([#921](https://github.com/rouge-ruby/rouge/pull/921) by t-b)
* Julia Lexer
  * Various improvements and fixes ([#912](https://github.com/rouge-ruby/rouge/pull/912) by ararslan)
* Kotlin Lexer
  * Recognize `.kts` as valid file extension ([#908](https://github.com/rouge-ruby/rouge/pull/908) by mkobit)
* CSS Lexer
  * Minor fixes ([#916](https://github.com/rouge-ruby/rouge/pull/916) by miparnisari)
* HTML Lexer
  * Minor fixes ([#916](https://github.com/rouge-ruby/rouge/pull/916) by miparnisari)
* Javascript Lexer
  * Minor fixes ([#916](https://github.com/rouge-ruby/rouge/pull/916) by miparnisari)
* Markdown Lexer
  * Images may not have alt text ([#904](https://github.com/rouge-ruby/rouge/pull/904) by Himura2la)
* ERB Lexer
  * Fix greedy comment matching ([#902](https://github.com/rouge-ruby/rouge/pull/902) by ananace)

## version 3.1.1: 2018-01-31

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.1.0...v3.1.1)

* Perl
  * [Fix \#851: error on modulo operato in Perl by miparnisari · Pull Request \#853 · rouge-ruby/rouge](https://github.com/rouge-ruby/rouge/pull/853)
* JavaScript
  * [Detect \*\.mjs files as being JavaScript by Kovensky · Pull Request \#866 · rouge-ruby/rouge](https://github.com/rouge-ruby/rouge/pull/866)
* Swift
  [\[Swift\] Undo parsing function calls with trailing closure by dan\-zheng · Pull Request \#862 · rouge-ruby/rouge](https://github.com/rouge-ruby/rouge/pull/862)
* Vue
  * [Fix load SCSS in Vue by purecaptain · Pull Request \#842 · rouge-ruby/rouge](https://github.com/rouge-ruby/rouge/pull/842)

## version 3.1.0: 2017-12-21

Thanks a lot for contributions; not only for the code, but also for the issues and review comments, which are vitally helpful.

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v3.0.0...v3.1.0)

* gemspec
  * Add source code and changelog links to gemspec [#785](https://github.com/rouge-ruby/rouge/pull/785) by @timrogers
* General
  * Fix #796: comments not followed by a newline are not highlighted [#797](https://github.com/rouge-ruby/rouge/pull/797) by @tyxchen
* Elem
  * Add Elm language support [#744](https://github.com/rouge-ruby/rouge/pull/744) by @dmitryrogozhny
* Ruby
  * Add the .erb file extension to ruby highlighting [#713](https://github.com/rouge-ruby/rouge/pull/713) by @jstumbaugh
* Hack
  * Add basic Hack support [#712](https://github.com/rouge-ruby/rouge/pull/712) by @fredemmott
* F#
  * Allow double backtick F# identifiers [#793](https://github.com/rouge-ruby/rouge/pull/793) by @nickbabcock
* Swift
  * Swift support for backticks and keypath syntax  [#794](https://github.com/rouge-ruby/rouge/pull/794) by @johnfairh
  * [Swift] Tuple destructuring, function call with lambda argument [#837](https://github.com/rouge-ruby/rouge/pull/837) by @dan-zheng
* Python
  * Add async and await keywords to Python lexer [#799](https://github.com/rouge-ruby/rouge/pull/799) by @BigChief45
* Shell
  * Add missing shell commands and missing GNU coreutils executables [#798](https://github.com/rouge-ruby/rouge/pull/798) by @kernhanda
* PowerShell
  * Add JEA file extensions to powershell [#807](https://github.com/rouge-ruby/rouge/pull/807) by @michaeltlombardi
* SASS / SCSS
  * Don't treat `[` as a part of an attribute name in SCSS [#839](https://github.com/rouge-ruby/rouge/pull/839) by @hibariya
* Haskell
  * Don't treat `error` specially in Haskell [#834](https://github.com/rouge-ruby/rouge/pull/834) by @enolan
* Rust
  * Rust: highlight the "where" keyword [#823](https://github.com/rouge-ruby/rouge/pull/823) by @lvillani

## version 3.0.0: 2017-09-21

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v2.2.1...v3.0.0)

There is no breaking change in the public API, but internals' is changed.

* general:
  * dropped support for Ruby 1.9, requireing Ruby v2.0.0 (#775 by gfx)
  * [Internal API changes] refactored disaambiguators to removes the use of analyze_text's numeric score interface (#763 by jneen)
    * See https://github.com/rouge-ruby/rouge/pull/763 for details
  * added `rouge guess $file` sub-command to test guessers (#773 by gfx)
  * added `Rouge::Lexer.guess { fallback }` interface (#777 by gfx)
  * removes BOM and normalizes newlines in input sources before lexing (#776 by gfx)
* kotlin:
  * fix errors in generic functions (#782 by gfx; thanks to @rongi for reporting it)
* haskell:
  * fix escapes in char literals (#780 by gfx; thanks to @Tosainu for reporting it)

## version 2.2.1: 2017-08-22

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v2.2.0...v2.2.1)

* powershell:
  * Adding PowerShell builtin commands for version 5 (#757 thanks JacodeWeerd)
* general:
  * Rouge::Guessers::Modeline#filter: reduce object allocations (#756 thanks @parkr)

## version 2.2.0: 2017-08-09

[Comparison with the previous version](https://github.com/rouge-ruby/rouge/compare/v2.1.1...v2.2.0)

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

[#114]: https://github.com/rouge-ruby/rouge/pull/114

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

[perf-0.5]: https://github.com/rouge-ruby/rouge/pull/41#issuecomment-23561787

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
