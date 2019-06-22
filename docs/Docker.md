# Using Docker for Rouge development

[Docker](https://www.docker.com/) can be used to avoid having to install Ruby and all the dependencies locally.

Clone the project first, and navigate into your clone:

```bash
$ git clone https://github.com/jneen/rouge.git
$ cd rouge
```

## Install the dependencies

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor ruby bundle
```

Let's unpack this:
- `docker run -it`: Run an command in a new container. `-t` is not strictly necessary but allows nice colors in the output
- `-v $PWD:app`: That maps the current folder into the `/app` path within the container. Used in conjunction with `-w` (see below), that allows the container to run as if it were inside this directory
- `-v /tmp/vendor:/vendor`: That maps an arbitrary `vendor` folder into the `/vendor` path within the container. This is to persist the installed dependencies across Docker commands, otherwise you would have to re-install them every time as containers are ephemeral by nature
- `-e BUNDLE_PATH=/vendor`: That sets an environment variable inside the container that tells Bundler to lookup the dependencies from the `/vendor` path (that we've mapped to our host machine with the previous line)
- `ruby`: Tells it which image to use for the container. Ruby is part of the official library of "base" Docker images
- `bundle` is the command to run within the container

## Run the tests

Just replace the `bundle` command with `rake`:

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor ruby rake
```

## Run Rack

```bash
$ docker run -t -v $PWD:/app -v /tmp/vendor:/vendor -w /app -e BUNDLE_PATH=/vendor -p 9292:9292 ruby bundle exec rackup --host 0.0.0.0
```

The additional command line flags are:
- `-p 9292:9292`: Expose the port 9292 of the container to the host, on the same port
- `bundle exec rackup --host 0.0.0.0`: Run Rack, and ask it to listen on all addresses. Without this it will only listen on the `localhost` of the container that won't be available from the host machine

You should be able to visit http://localhost:9292/ at this point.
