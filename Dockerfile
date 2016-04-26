FROM outstand/ruby-base:2.2.4-alpine
MAINTAINER Ryan Schlesinger <ryan@outstand.com>

RUN addgroup bridge && \
    adduser -S -G bridge bridge

ENV CONSUL_BRIDGE_VERSION=0.1.1

# Use this to install an official release
RUN apk --no-cache add libxml2 libxslt \
    && apk --no-cache add --virtual build-dependencies build-base libxml2-dev libxslt-dev \
    && gem install nokogiri -- --use-system-libraries \
    && gem install consul_bridge -v ${CONSUL_BRIDGE_VERSION} \
    && apk del build-dependencies

# Use this to install a development version
# RUN apk --no-cache add build-base libxml2-dev libxslt-dev
# COPY Gemfile consul_bridge.gemspec /consul_bridge/
# COPY lib/consul_bridge/version.rb /consul_bridge/lib/consul_bridge/
# RUN cd /consul_bridge \
#     && bundle config build.nokogiri --use-system-libraries \
#     && bundle install
# COPY . /consul_bridge/
# RUN cd /consul_bridge \
#     && bundle exec rake install

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV DUMB_INIT_SETSID 0
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []
