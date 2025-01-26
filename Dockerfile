# Use the official Ruby image because the Rails images have been deprecated
FROM ruby:2.7.6

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /ohana-api

COPY Gemfile /ohana-api/Gemfile
COPY Gemfile.lock /ohana-api/Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without production

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8080

COPY . /ohana-api

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]
