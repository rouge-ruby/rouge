<!--
# @title Using Docker
-->
# Using Docker

So you want to help with Rouge development but aren't too keen on needing to
install Ruby and whatever dependencies are required by Rouge?
[Docker](https://www.docker.com/) to the rescue!

Docker can be used as a way install Ruby, Rouge and the development dependencies
in a self-contained environment for development. In addition to providing an
alternative for users who don't want to install Ruby, it's also a good choice
for users with an existing installation of Ruby with which they don't want to
interfere.

## Prerequisites

This guide assumes you have Docker and Git installed.

For a guide on installing Docker, we recommend [Docker's official
documentation][dk-inst-docs]. For a guide on installing Git, take a look at
[GitHub's documentation][gh-inst-docs].

[dk-inst-docs]: https://docs.docker.com/get-started/
[gh-inst-docs]: https://help.github.com/en/articles/set-up-git

## Installing

### Downloading Rouge

Clone the project first, and navigate into your clone:

```bash
$ git clone https://github.com/rouge-ruby/rouge.git
$ cd rouge
```

### Configuring the Container

The following line of code sets up Docker with Ruby and Rouge's development
dependencies:

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor ruby bundle
```

Pretty sweet. Let's unpack this:

- `docker run -it`: Runs the command in a new container. `-t` is not strictly
  necessary but allows nice colors in the output.

- `-v $PWD:app`: Maps the current folder into the `/app` path within the
  container. Used in conjunction with `-w` (see below), this allows the
  container to run as if it were inside this directory.

- `-v /tmp/vendor:/vendor`: Maps an arbitrary `vendor` folder into the `/vendor`
  path within the container. This is to persist the installed dependencies
  across Docker commands, otherwise you would have to re-install each time as
  containers are ephemeral by nature.

- `-e BUNDLE_PATH=/vendor`: Sets an environment variable inside the container
  that tells Bundler to lookup the dependencies from the `/vendor` path (that
  we've mapped to our host machine with the previous line)

- `ruby`: Tells Docker which image to use for the container. The `ruby` image is
  part of the official library of "base" Docker images.

- `bundle`: Runs the `bundle` command within the container.

## Executing Commands

### Running Rake

Just replace the `bundle` command with `rake`:

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor ruby rake
```

### Running Rack

Similarly, we can run Rack by replacing `bundle` with `rackup`:

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor -p 9292:9292 ruby bundle exec rackup --host 0.0.0.0
```

The additional command line flags are:

- `-p 9292:9292`: Exposes port 9292 of the container to the same port on the
  host.

- `bundle exec rackup --host 0.0.0.0`: Runs Rack and asks it to listen on all
  addresses. Without this it will only listen on the `localhost` of the
  container and we won't be able to access the server from the host machine.

You should be able to visit <http://localhost:9292> at this point.

## Conclusion

Now that you've got Docker set up, perhaps you'd like to work on
{file:docs/LexerDevelopment.md a lexer}?
