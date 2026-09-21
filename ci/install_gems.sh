#!/usr/bin/env bash

execd() {
  echo "$@" >&2
  "$@" || exit $?
}

execd cd /run

for RUBY_VERSION in $(< /run/ruby-versions.txt); do
  # this script changes the /opt/rubies/current symlink
  execd /opt/rubies/"$RUBY_VERSION"/activate

  execd ruby --version
  execd bundle install

  # make sure to remove the generated Gemfile.lock, since
  # the specific gems installed will be different per ruby
  # version
  execd rm -f Gemfile.lock
done
