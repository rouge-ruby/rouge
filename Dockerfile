FROM ruby:2.4.1
COPY . /src
WORKDIR /src
RUN bundle install
ENTRYPOINT ["rackup", "-o", "0.0.0.0"]
CMD ["-p", "9292"]
