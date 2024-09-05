FROM ruby:3.2.2

WORKDIR /price_alert_app

#RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs

COPY Gemfile* ./
RUN gem install bundler:2.3.10 && bundle install

COPY . .

#RUN bundle exec rake assets:precompile

ARG DEFAULT_PORT 3000
EXPOSE ${DEFAULT_PORT}

# Precompile assets and run database migrations
CMD ["bash", "-c", "bundle exec rake db:create db:migrate && bundle exec rails s -b '0.0.0.0'"]
