# syntax=docker/dockerfile:1
# Imagen de produccion de la API de BalanceFood (Rails 7.1, modo API).
#
#   docker build -t secondfood-backend .
#   docker run -d -p 3000:3000 -e DATABASE_URL=... -e SECRET_KEY_BASE=... \
#     -e FRONTEND_ORIGIN=https://websecondfood.frubilarz.cl secondfood-backend
#
# El entrypoint corre `rails db:migrate` antes de levantar el servidor.

ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# curl lo usa el Health Check del pipeline (docker exec); libpq5 es el cliente de PostgreSQL.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
# El Gemfile.lock fija la version de bundler (BUNDLED WITH); se instala la misma.
RUN gem install bundler -v "$(tail -1 Gemfile.lock | tr -d ' ')" --no-document && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p log tmp && \
    chown -R rails:rails log tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
