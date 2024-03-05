FROM ruby:3.3.0-slim AS builder

ENV LANG en_US.UTF-8

RUN apt-get update -qq \
  && apt-get install -y \
  apt-transport-https \
  build-essential \
  ca-certificates \
  curl \
  wget \
  git \
  libpq-dev \
  && apt-get update -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile* /app/
RUN gem install bundler \
  && bundle config without "development test" \
  && bundle config frozen 1 \
  && bundle install -j4 --retry 3 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . /app

FROM ruby:3.3.0-slim

ENV LANG en_US.UTF-8

RUN apt-get update -qq \
  && apt-get install -y libjemalloc2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 app && \
  useradd --uid 1000 --no-log-init --create-home --gid app app
USER app

COPY --from=builder --chown=app:app /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder --chown=app:app /usr/local/lib /usr/local/lib
COPY --from=builder --chown=app:app /app/ /app

WORKDIR /app
CMD rake falsify --trace
