FROM ruby:2.7.0

ARG RAILS_ENV
ARG SECRET_KEY_BASE

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y imagemagick libmagickwand-dev

ENV RAILS_ROOT /var/www
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

ENV RAILS_ENV $RAILS_ENV
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

RUN bundle exec rake assets:precompile

RUN rake db:create db:migrate

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]