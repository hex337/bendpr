FROM elixir:1.5
MAINTAINER hex337@gmail.com

RUN apt-get update && apt-get install --yes postgresql-client

ADD . /app

RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /app
EXPOSE 4000
CMD ["./run.sh"]
