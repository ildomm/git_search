FROM ruby:3.3.0

RUN apt-get update -qq && apt-get install -y build-essential
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install
COPY . .
