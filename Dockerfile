FROM elixir:1.18.4-otp-27

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git inotify-tools chromium ghostscript

WORKDIR /usr/src/app

RUN mix local.hex --force
