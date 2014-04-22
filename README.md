#Ohana API

[![Stories in Ready](https://badge.waffle.io/codeforamerica/ohana-api.png?label=ready)](https://waffle.io/codeforamerica/ohana-api) [![Build Status](https://travis-ci.org/codeforamerica/ohana-api.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-api)

This is the API portion of the [Ohana API](http://ohanapi.org) project, an open source community resource platform developed by [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) during their Code for America Fellowship in 2013, in partnership with San Mateo County's Human Services Agency. The goal of the project is to make it easier for residents in need to find services they are eligible for.

Before we started working on the Ohana API, the search interface that residents and social workers in San Mateo County had access to was the Peninsula Library System's [CIP portal](http://catalog.plsinfo.org:81/). As a demonstration of the kind of applications that can be built on top of the Ohana API, we developed a [better search interface](http://smc-connect.org) ([repo link](https://github.com/codeforamerica/human_services_finder)) that consumes the API via our [Ruby wrapper](https://github.com/codeforamerica/ohanakapa). We also built an [admin site](https://github.com/codeforamerica/ohana-api-admin) to allow organizations to update their own information.

## Demo
You can see a running version of the application at
[http://ohana-api-demo.herokuapp.com/](http://ohana-api-demo.herokuapp.com/).

## Current Status
We are happy to announce that this project has been awarded a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), which means we get to keep working on it in 2014! Our primary goals this year are: simplifying the installation process, streamlining the code, reducing dependencies, and preparing the project for broader installation by a variety of organizations and governments.

One of the major changes (that is now complete as of April 17, 2014) is the replacement of MongoDB with Postgres. The main reason for that change was to reduce dependencies, but another important reason is that we wanted to upgrade the app to Rails 4, but Mongoid didn't (maybe still doesn't?) support Rails 4.

The next change underway in April is replacing Elasticsearch with the full-text search capabilities in Postgres.

Because the project will be undergoing these major changes, we don't recommend using it for a production app just yet, but please feel free to try it out and provide feedback!

## Data Schema
If you would like to try out the current version of the project that uses Postgres, please read the Wiki article about [Populating the Postgres DB from a JSON file](https://github.com/codeforamerica/ohana-api/wiki/Populating-the-Postgres-database-from-a-JSON-file). That article documents the current schema and data dictionary, but please note that this will be in flux as we are working with various interested parties to define a [Human Services Data Specification](https://github.com/codeforamerica/OpenReferral).

## Taxonomy
By default, this project uses the [Open Eligibility](http://openeligibility.org) taxonomy to assign Services to [Categories](https://github.com/codeforamerica/ohana-api/blob/master/app/models/category.rb).
If you would like to use your own taxonomy, feel free to update this rake task to [create your own hierarchy or tree structure](https://github.com/codeforamerica/ohana-api/blob/master/lib/tasks/oe.rake). Then run `rake create_categories`.

The easiest way to assign categories to a service is to use the [Ohana API Admin](https://github.com/codeforamerica/ohana-api-admin/blob/master/app/controllers/hsa_controller.rb#L183-187) interface. Here's a screenshot:

![Editing categories in Ohana API Admin](https://github.com/codeforamerica/ohana-api/raw/master/categories-in-ohana-api-admin.png)

You can also try it from the Rails console, mimicking how the API would do it when it receives a [PUT request to update a service's categories](https://github.com/codeforamerica/ohana-api/blob/master/app/api/ohana.rb#L239-257).

## API documentation
[http://ohana-api-demo.herokuapp.com/api/docs](http://ohana-api-demo.herokuapp.com/api/docs)

[Search documentation](http://ohana-api-demo.herokuapp.com/api/docs#!/api/GET_api_search_format_get_15)

## Ruby wrapper
[https://github.com/codeforamerica/ohanakapa](https://github.com/codeforamerica/ohanakapa)

## Apps that are using the Ohana API
[SMC-Connect](http://www.smc-connect.org)
[GitHub repo for SMC-Connect](https://github.com/codeforamerica/human_services_finder)

[Ohana API Admin site](https://github.com/codeforamerica/ohana-api-admin)

[Ohana SMS](https://github.com/marks/ohana-sms)

## Stack Overview

* Ruby version 2.1.1
* Rails version 4.0.4
* Postgres
* Redis
* ElasticSearch <=1.0.1
* API framework: Grape
* Testing Frameworks: RSpec, Factory Girl, Capybara

## Deploying to Heroku
See the [Wiki](https://github.com/codeforamerica/ohana-api/wiki/How-to-deploy-the-Ohana-API-to-your-Heroku-account).

## Installation - The Fast & Easy Way

We have a [virtual machine](https://github.com/codeforamerica/ohana-api-dev-box) with all the tools you need to get started.

## Installation - The Long Way

Please note that the instructions below have only been tested on OS X. If you are running another operating system and run into any issues, feel free to update this README, or open an issue if you are unable to resolve installation issues.

###Prerequisites

#### Git, Ruby 2.1.1, Rails 4.0.4 (+ Homebrew on OS X)
**OS X**: [Set up a dev environment on OS X with Homebrew, Git, RVM, Ruby, and Rails](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

**Windows**: Try [RailsInstaller](http://railsinstaller.org), along with some of these [tutorials](https://www.google.com/search?q=install+rails+on+windows) if you get stuck.

**Linux**:

* To make sure you are using the right Ruby version, we recommend [RVM](http://rvm.io), but you can use other Ruby version managers.
* You need a Javascript runtime. We recommend Node.JS (if you have a good reason not to use it, [there are other options](https://github.com/sstephenson/execjs)). On Ubuntu, it's as simple as <code>sudo apt-get install nodejs</code>. On others, [check the official instructions](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).


#### PostgreSQL
**OS X**

On OS X, the easiest way to install PostgreSQL is with [Postgres.app](http://postgresapp.com/)

If that doesn't work, try this [tutorial](http://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/).

**Other**

See the Downloads page on postgresql.org for steps to install on other systems: [http://www.postgresql.org/download/](http://www.postgresql.org/download/)


#### Redis
**OS X**

On OS X, the easiest way to install Redis is with Homebrew:

    brew install redis

Follow the Homebrew instructions if you want Redis to start automatically every time you restart your computer. Otherwise launch Redis manually in a separate Terminal tab or window:

    redis-server

[Redis installation instructions using MacPorts](https://github.com/codeforamerica/ohana-api/wiki/Installing-Redis-with-MacPorts-on-OS-X) are available on the wiki.

**Other**

See the Download page on Redis.io for steps to install on other systems: [http://redis.io/download](http://redis.io/download)

#### ElasticSearch <=1.0.1
**OS X**

Please make sure you are using Elasticsearch 1.0.1 or lower. This app is currently not compatible with Elasticsearch 1.1.0.

On OS X, the easiest way to install ElasticSearch is with Homebrew:

    brew install https://raw.github.com/Homebrew/homebrew/9b8103f6fb570dc3a5ce5b5b84cb76fb6915cace/Library/Formula/elasticsearch.rb

Follow the Homebrew instructions to launch ElasticSearch.

If you already had 1.0.1 and then upgraded to 1.1.0, you can switch back to 1.0.1 with this command:

    brew switch elasticsearch 1.0.1

**Other**

Visit the Download page on elasticsearch.org for steps to install on other systems: [http://www.elasticsearch.org/download/](http://www.elasticsearch.org/download/)

### Clone the app on your local machine:

From the Terminal, navigate to the directory into which you'd like to create a copy of the Ohana API source code. For instance, on OS X `cd ~` will place you in your home directory. Next download this repository into your working directory with:

    git clone git://github.com/codeforamerica/ohana-api.git
    cd ohana-api

### Install the dependencies and prepare the DB:

    script/bootstrap

_Note: Installation and preparation can take several minutes to complete!_

If you get a `permission denied` message, set the correct permissions:

    chmod -R 755 script

then run `script/bootstrap` again.

### Set up the environment variables
Inside the `config` folder, you will find a file named `application.example.yml`. Rename it to `application.yml` and double check that it is in your `.gitignore` file (it should be by default).

In `config/application.yml`, set the following environment variables so that the tests can pass, and so you can run the [Ohana API Admin](https://github.com/codeforamerica/ohana-api-admin) app locally:

    API_BASE_URL: http://localhost:8080/api/
    API_BASE_HOST: http://localhost:8080/
    ADMIN_APP_TOKEN: your_token

`your_token` can be any string you want for testing purposes, but in production, you should use a random string, which you can generate from the command line:

    rake secret

### Run the app
Start the app locally on port 8080:

    rails s -p 8080

If for some reason, you can't run on port 8080, make sure you update `API_BASE_URL` and `API_BASE_HOST` in `config/application.yml` if you change the port number. You'll also need to update the port number in `OHANA_API_ENDPOINT` when running the Admin Interface.

### Verify the app is returning JSON
To see all locations, 30 per page:

    http://localhost:8080/api/locations

To go the next page (the page parameter works for all API responses):

    http://localhost:8080/api/locations?page=2

Note that the sample dataset has less than 30 locations, so the second page will be empty.

Search for organizations by keyword and/or location:

    http://localhost:8080/api/search?keyword=food
    http://localhost:8080/api/search?keyword=counseling&location=94403
    http://localhost:8080/api/search?location=redwood city, ca

Search for organizations by languages spoken at the location:

    http://localhost:8080/api/search?keyword=food&language=spanish

The language parameter can be used alone:

    http://localhost:8080/api/search?language=tagalog

Searches with the location parameter return results sorted by distance. Searches with the keyword parameter return results sorted by relevance based on a match between the search term and the organization's `keywords` field.

Pagination info is available via the following HTTP response headers :

X-Total-Count

X-Total-Pages

X-Current-Page

X-Next-Page

X-Previous-Page

Pagination links are available via the `Link` header.

Here is an example response using cURL:
`curl -s -D - http://ohana-api-demo.herokuapp.com/api/search\?keyword\=shelter -o /dev/null`

Response Headers:

```
HTTP/1.1 200 OK
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json
Date: Wed, 19 Feb 2014 14:16:40 GMT
Etag: "f104eaabf805bd034a7c376f15b66a4b"
Link: <http://ohana-api-demo.herokuapp.com/api/search?keyword=shelter&page=3>; rel="last", <http://ohana-api-demo.herokuapp.com/api/search?keyword=shelter&page=2>; rel="next"
Server: nginx/1.4.4 + Phusion Passenger 4.0.37
Status: 200 OK
X-Current-Page: 1
X-Next-Page: 2
X-Powered-By: Phusion Passenger 4.0.37
X-Rack-Cache: miss
X-Request-Id: af51fefe-4eee-48a6-8172-f232001976bd
X-Runtime: 0.699663
X-Total-Count: 86
X-Total-Pages: 3
X-Ua-Compatible: IE=Edge,chrome=1
Content-Length: 140193
Connection: keep-alive
```

If you're a Rubyist, you can access this info easily by using our Ruby wrapper. Check out the [Accessing HTTP Responses](https://github.com/codeforamerica/ohanakapa-ruby#accessing-http-responses) section of the README.

If you just want to fetch the results for the next page, for example, then you should use the `Link` headers as opposed to constructing your own URLs based on the other pagination headers. The wrapper makes that easy too:

```ruby
shelters = Ohanakapa.search("search", keyword: "shelter")
next_page_results = Ohanakapa.last_response.rels[:next].get.data
```
If you want to append the next page results to the previous results:
```ruby
shelters = Ohanakapa.search("search", keyword: "shelter")
shelters.concat Ohanakapa.last_response.rels[:next].get.data
```

Read more about [search](http://ohana-api-demo.herokuapp.com/api/docs#!/api/GET_api_search_format_get_15) in the API docs.

### Tools
We recommend these tools to interact with APIs:

[JSONView](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc) A Google Chrome extension for formatting the JSON response so it is easier to read in the browser.

[HTTPie](https://github.com/jkbr/httpie) command line utility for making interactions with web services from the command line more human friendly.

### Resetting the DB
If you want to wipe out the local test DB and reset it with the sample data, run this command:

    script/reset

### User authentication
The app automatically sets up users you can [sign in](http://localhost:8080/users/sign_in) with. Their username and password are stored in [db/seeds.rb](https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb).


### Test the app
First, run this command to make sure your local test database is up to date:

    script/test

Then run tests locally with this simple command:

    rspec

For faster tests (optional):

    gem install zeus
    zeus start #in a separate Terminal window or tab
    zeus rspec spec

Read more about [Zeus](https://github.com/burke/zeus).

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-api/tree/master/spec) directory.

## Contributing

In the spirit of open source software, **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by suggesting labels for our issues
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues](https://github.com/codeforamerica/ohana-api/issues)
* by reviewing patches
* [financially](https://secure.codeforamerica.org/page/contribute)

## Submitting an Issue
We use the [GitHub issue tracker](https://github.com/codeforamerica/ohana-api/issues) to track bugs and features. Before submitting a bug report or feature request, check to make sure it hasn't already been submitted. When submitting a bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any details that may be necessary to reproduce the bug, including your gem version, Ruby version, and operating system. Ideally, a bug report should include a pull request with failing specs.

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `rspec`. If your specs pass, return to step 3. In the spirit of Test-Driven Development, you want to write a failing test first, then implement the feature or bug fix to make the test pass.
5. Implement your feature or bug fix.
6. Run `rspec`. If your specs fail, return to step 5.
7. Run `metric_fu -r`. This will go through all the files in the app and analyze the code quality and check for things like trailing whitespaces and hard tabs. When it's done, it will open a page in your browser with the results. Click on `Cane` and `Rails Best Practices` to check for files containing trailing whitespaces and hard tabs. If you use Sublime Text 2, you can use the [TrailingSpaces](https://github.com/SublimeText/TrailingSpaces) plugin to highlight the trailing whitespaces and delete them. If the report complains about "hard tabs" in a file, change your indentation to `spaces` by clicking on `Tabs: 2` at the bottom of your Sublime Text 2 window, then selecting `Convert Indentation to Spaces`. As for the code itself, we try to follow [GitHub's Ruby styleguide](https://github.com/styleguide/ruby).
8. Add, commit, and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/codeforamerica/ohana-api) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.