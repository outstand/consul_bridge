FROM outstand/ruby-base:2.2.4-alpine
MAINTAINER Ryan Schlesinger <ryan@outstand.com>

RUN addgroup bridge && \
    addgroup -g 1101 docker && \
    adduser -S -G bridge -G docker bridge

RUN apk --no-cache add build-base libxml2-dev libxslt-dev
COPY . /consul_bridge/
RUN cd /consul_bridge \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle install \
    && bundle exec rake install

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV DUMB_INIT_SETSID 0
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["consul_bridge"]
