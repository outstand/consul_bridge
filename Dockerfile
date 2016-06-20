FROM outstand/ruby-base:2.3.1-alpine
MAINTAINER Ryan Schlesinger <ryan@outstand.com>

RUN addgroup -S bridge && \
    adduser -S -G bridge bridge && \
    addgroup -g 1101 docker && \
    addgroup bridge docker

RUN apk --no-cache add build-base openssh

ENV USE_BUNDLE_EXEC true

WORKDIR /consul_bridge
COPY Gemfile consul_bridge.gemspec /consul_bridge/
COPY lib/consul_bridge/version.rb /consul_bridge/lib/consul_bridge/
COPY scripts/fetch-bundler-data.sh /consul_bridge/scripts/fetch-bundler-data.sh

ARG bundler_data_host
RUN /consul_bridge/scripts/fetch-bundler-data.sh ${bundler_data_host} && \
    bundle install && \
    git config --global push.default simple
COPY . /consul_bridge/
RUN ln -s /consul_bridge/exe/consul_bridge /usr/local/bin/consul_bridge

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh

ENV DUMB_INIT_SETSID 0
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]
