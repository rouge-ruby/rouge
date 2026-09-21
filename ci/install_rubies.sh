#!/usr/bin/env bash

execd() {
  echo "$@" >&2
  "$@" || exit $?
}

execd cd /run
execd mkdir -p /tmp

# using ruby-build from git instead of from the package manager
# because the debian ruby-build does not include eol versions
# that we still support.
execd git clone --depth=1 https://github.com/rbenv/ruby-build /tmp/ruby-build

# this just copies the shell script and share files to /usr/local,
# no compilation here
pushd /tmp/ruby-build
  PREFIX=/usr/local execd make install
popd

for RUBY_VERSION in $(< /run/ruby-versions.txt); do
  prefix=/opt/rubies/"$RUBY_VERSION"

  # here's where we actually compile the ruby
  execd ruby-build --verbose "$RUBY_VERSION" "$prefix"

  # make sure the BUNDLE_USER_HOME dir exists for this ruby
  execd mkdir -p "$prefix/bundle"

  # install a script that changes the /opt/rubies/current
  # symlink to point to this ruby
  execd cat <<EOF >"$prefix/activate"
#!/usr/bin/env bash
rm -f /opt/rubies/current
ln -s $(printf %q "$prefix") /opt/rubies/current
EOF
  execd chmod +x "$prefix"/activate
done

# check to make sure there were *any* rubies installed
if [[ -z "$prefix" ]]; then
  echo 'no rubies installed - check that the ruby-versions list in .forgejo/workflows/ruby.yml is non-empty and being read correctly' >&2
  exit 1
fi

# last prefix is still in $prefix
execd "$prefix"/activate

# clean up temp files, including all the ruby sources from ruby-build
execd rm -rf /tmp/*
