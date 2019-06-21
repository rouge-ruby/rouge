<!--
# @title Development Environment
-->
# Development Environment

## Introduction

Rouge is written in Ruby and has a number of development dependencies. To
develop new features for Rouge (like a lexer for a new syntax) or to fix bugs,
you need to set up a development environment.

### Ruby and Git

First thing's first. This guide is _not_ a guide to installing Ruby and Git.
There are a number of excellent resources out there explaining how to do these
things. For Ruby, we recommend [the official documentation][rb-inst-docs] and
for Git, [GitHub's documentation][gh-inst-docs].

[rb-inst-docs]: https://www.ruby-lang.org/en/documentation/installation/
[gh-inst-docs]: https://help.github.com/en/articles/set-up-git

### Terminal Emulators

This guide assumes you are familiar with the _command line_. The command line is
accessed through a _terminal emulator_. In macOS, the default emulator is called
"Terminal" and can be found by searching for "Terminal" in Spotlight. In
Windows, depending on your version, you may want to install a third-party
emulator like [Cygwin][]. In Linux, well, you're probably reading this at the
command line.

[Cygwin]: https://cygwin.com/

### GitHub

The official Rouge repository is on GitHub and we use GitHub to coordinate
development. While you don't _need_ a GitHub account to hack on Rouge, you're
going to need one to contribute your improvements back to the Rouge community.
Creating [an account][gh-make-acc] is free of charge. And just think how awesome
it'll be when you take your collaboration to the "next level".

[gh-make-acc]: https://github.com/join

## Getting Rouge

### Forking the Repository

To develop Rouge, we're going to create a "fork" of Rouge where we can make our
changes. These will be happily isolated from everyone else and then—through the
magic of Git—mergeable back into the main project later.

First, visit [the front page][rouge-fp] of Rouge's repo on GitHub. Unless you're
crazy and are trying to develop code on your phone (like perhaps I am doing
right now), you'll see a button near the top right of your browser window that
will say "Fork". Click this and GitHub will ask where you want to create your
fork. Select your account and—boom!—you've just forked Rouge.

[rouge-fp]: https://github.com/rouge-ruby/rouge

### Cloning Your Fork

The next thing to do is to get your fork onto your computer. Git makes this
easy. In the directory you want to hold your repository, type:

```shell
git clone git@github.com:<your_github_account_name>/rouge.git
```

Git will reach out to GitHub, grab the code and put it in a directory called
`rouge/`.

## Installing Development Dependencies

Ruby provides support for using external "packages" of Ruby code. These packages
are called _gems_. While Rouge itself does not depend on any gems to perform
syntax highlighting, it does have a number of dependencies that you need to
install to _develop_ Rouge. These are the development dependencies.

### Installing Bundler

The easiest way to install Rouge's development dependencies is using
[Bundler][]. Bundler is itself a gem and we'll install it differently to how we
install the other dependencies.

[Bundler]: https://bundler.io/

If you already develop with Ruby, you no doubt have Bundler installed. You can
check if you do by typing `bundle -v` at the command line. If you don't see the
version number then you need to install Bundler. To do this, type:

```shell
gem install bundler
```

Ruby's `gem` tool will grab the latest Bundler package and install it. Once
that's complete, you're ready to rock.

### Installing the Dependencies

Rouge comes with a list of gems it depends upon called a _Gemfile_. Make sure
you're at the top level of your clone of your repository and type:

```shell
bundle install --path vendor
```

This command tells Bundler to install the gems Rouge in the Gemfile into a
directory called `vendor/`. This has one drawback (explained below) but means
the gems we use for Rouge are isolated from the other gems we may have installed
on our system. This will be tremendously helpful in avoiding conflicts that
arise because of the use of incompatible versions of a gem.

The one drawback is that we will need to tell Ruby every time we run our Rouge
code that it needs to look for the gems in `vendor/`. Bundler makes this easy by
providing the command `bundle exec`. So if we want to run our Rake tests, we
type `bundle exec rake` rather than just `rake`.

## Using Branches

It's best to develop in a _branch_. You can create a branch by typing:

```shell
git checkout -b <name_of_your_branch>
```

You don't need to do it this way but Rouge maintainers often use the format 
`feature.<name>` for features and `bugfix.<name>` for bug fixes.

Using branches will make it easier for others to collaborate with you and make
it easier for you to start fresh if you screw things up from your last stable
state. You can read more about branches on [GitHub][gh-branch-docs].

[gh-branch-docs]: https://help.github.com/en/articles/about-branches

## Next Steps

You're now ready to roll. Here are the things you can do from the top level of
your cloned repository:

1. **Run the Visual Test App**
   Rouge includes a little web app you can run to display highlighted code. You
   can run this by typing `bundle exec rackup`. By default, this will start a
   web server on port 9292. You can access it by going to
   <http://localhost:9292> with Rack running. If everything is working, you'll
   see little snippets of code for each lexer in the repository. You can look at
   a visual sample by clicking on the name of the lexer.

2. **Run the Tests**
   Rouge comes with a test suite you can run to check for errors in your code.
   You can run this using Rake. Just type `bundle exec rake` and you'll
   (hopefully) be greeted by a series of dots that indicate a successful test.

3. **Check Code Quality**
   Rouge uses tbe popular library [Rubocop][] for checking code quality. You can
   run Rubocop by—you guessed it—typing `bundle exec rubocop`.

   [Rubocop]: https://github.com/rubocop-hq/rubocop

You're all set up! Have fun hacking on Rouge!
