FROM outstand/ruby-base:2.3.1-alpine
MAINTAINER Ryan Schlesinger <ryan@outstand.com>

RUN addgroup bridge && \
    addgroup -g 1101 docker && \
    adduser -S -G bridge -G docker bridge

RUN apk --no-cache add build-base openssh

ENV USE_BUNDLE_EXEC true

COPY Gemfile consul_bridge.gemspec /consul_bridge/
COPY lib/consul_bridge/version.rb /consul_bridge/lib/consul_bridge/
RUN cd /consul_bridge \
    && bundle install \
    && git config --global push.default simple
COPY . /consul_bridge/
RUN ln -s /consul_bridge/exe/consul_bridge /usr/local/bin/consul_bridge

WORKDIR /consul_bridge

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV DUMB_INIT_SETSID 0
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]
