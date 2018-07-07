# Use the official Ruby image because the Rails images have been deprecated
FROM ruby:2.5.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/local/node \
    && curl -L https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.xz | tar Jx -C /usr/local/node --strip-components=1
RUN ln -s ../node/bin/node /usr/local/bin/

# PhantomJS is required for running tests
ENV PHANTOMJS_SHA256 86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f

RUN mkdir /usr/local/phantomjs \
  && curl -o phantomjs.tar.bz2 -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && echo "$PHANTOMJS_SHA256 *phantomjs.tar.bz2" | sha256sum -c - \
  && tar -xjf phantomjs.tar.bz2 -C /usr/local/phantomjs --strip-components=1 \
  && rm phantomjs.tar.bz2

RUN ln -s ../phantomjs/bin/phantomjs /usr/local/bin/

WORKDIR /ohana-api

COPY Gemfile /ohana-api
COPY Gemfile.lock /ohana-api

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5 --without production

COPY . /ohana-api

EXPOSE 8080
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]
