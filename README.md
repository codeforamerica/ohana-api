[![Build Status](https://travis-ci.org/smcgov/ohana-api-smc.png?branch=master)](https://travis-ci.org/smcgov/ohana-api-smc)

#Ohana API - San Mateo County

This is the repo for the San Mateo County instance of the [Ohana API](http://ohanapi.org). The API exposes information about community resources in San Mateo County to make it easier for residents in need to find services they are eligible for.

## Apps that are using the Ohana API in San Mateo County
[SMC-Connect](http://www.smc-connect.org), a mobile-friendly website for looking up community and human services. ([GitHub repo for SMC-Connect](https://github.com/smcgov/SMC-Connect))

[SMC-Connect Admin site](http://admin.smc-connect.org), which allows organizations to update their own information. ([GitHub repo for SMC-Connect Admin](https://github.com/smcgov/SMC-Connect-Admin))

We encourage third-party developers to build additional applications on top of the API. You can register your app on our [developer portal](http://ohanapi.herokuapp.com) (branding work in progress), and view the [API documentation](http://ohanapi.herokuapp.com/api.docs).

## Taxonomy
We are currently using the [Open Eligibility](http://openeligibility.org) taxonomy to assign Services to [Categories](https://github.com/smcgov/ohana-api-smc/blob/master/app/models/category.rb).
Ohana API only accepts the categories defined by Open Eligibility.

The easiest way to assign categories to a service is to use the [Ohana API Admin](http://admin.smc-connect.org) interface. Here's a screenshot:

![Editing categories in Ohana API Admin](https://github.com/codeforamerica/ohana-api/raw/master/categories-in-ohana-api-admin.png)

## API documentation
[http://ohanapi.herokuapp.com/api/docs](http://ohanapi.herokuapp.com/api/docs)

[Search documentation](http://ohanapi.herokuapp.com/api/docs#!/api/GET_api_search_format_get_15)

## Ruby wrapper
[https://github.com/codeforamerica/ohanakapa](https://github.com/codeforamerica/ohanakapa)

## Stack Overview

* Ruby version 2.1.1
* Rails version 3.2.17
* MongoDB with the Mongoid ORM
* Redis
* ElasticSearch
* API framework: Grape
* Testing Frameworks: RSpec, Factory Girl, Capybara


## Installation
Please note that the instructions below have only been tested on OS X. If you are running another operating system and run into any issues, feel free to update this README, or open an issue if you are unable to resolve installation issues.

###Prerequisites

#### Git, Ruby 2.1+, Rails 3.2.17+ (+ Homebrew on OS X)
**OS X**: [Set up a dev environment on OS X with Homebrew, Git, RVM, Ruby, and Rails](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

**Windows**: Try [RailsInstaller](http://railsinstaller.org), along with some of these [tutorials](https://www.google.com/search?q=install+rails+on+windows) if you get stuck.


#### MongoDB
**OS X**

On OS X, the easiest way to install MongoDB (or almost any development tool) is with Homebrew:

    brew update
    brew install mongodb

Follow the Homebrew instructions for configuring MongoDB and starting it automatically every time you restart your computer. Otherwise, you can launch MongoDB manually in a separate Terminal tab or window with this command:

    mongod

[MongoDB installation instructions using MacPorts](https://github.com/codeforamerica/ohana-api/wiki/Installing-MongoDB-with-MacPorts-on-OS-X) are available on the wiki.

**Other**

See the Downloads page on mongodb.org for steps to install on other systems: [http://www.mongodb.org/downloads](http://www.mongodb.org/downloads)


#### Redis
**OS X**

On OS X, the easiest way to install Redis is with Homebrew:

    brew install redis

Follow the Homebrew instructions if you want Redis to start automatically every time you restart your computer. Otherwise launch Redis manually in a separate Terminal tab or window:

    redis-server

[Redis installation instructions using MacPorts](https://github.com/codeforamerica/ohana-api/wiki/Installing-Redis-with-MacPorts-on-OS-X) are available on the wiki.

**Other**

See the Download page on Redis.io for steps to install on other systems: [http://redis.io/download](http://redis.io/download)

#### ElasticSearch
**OS X**

On OS X, the easiest way to install ElasticSearch is with Homebrew:

    brew install elasticsearch

Follow the Homebrew instructions to launch ElasticSearch.

**Other**

Visit the Download page on elasticsearch.org for steps to install on other systems: [http://www.elasticsearch.org/download/](http://www.elasticsearch.org/download/)

### Clone the app on your local machine:

From the Terminal, navigate to the directory into which you'd like to create a copy of the Ohana API source code. For instance, on OS X `cd ~` will place you in your home directory. Next download this repository into your working directory with:

    git clone git://github.com/smcgov/ohana-api-smc.git
    cd ohana-api-smc

### Install the dependencies and prepare the DB:

    script/bootstrap

_Note: Installation and preparation can take several minutes to complete!_

If you get a `permission denied` message, set the correct permissions:

    chmod -R 755 script

then run `script/bootstrap` again.

In `config/application.yml`, set the `ADMIN_APP_TOKEN` environment variable so that the tests can pass, and so you can run the [SMC-Connect Admin](https://github.com/smcgov/SMC-Connect-Admin) app locally:

    ADMIN_APP_TOKEN: your_token

`your_token` can be any string you want for testing purposes, but in production, you should use a random string, which you can generate from the command line:

    rake secret

### Run the app
Start the app locally on port 8080 using Passenger:

    passenger start -p 8080

### Verify the app is returning JSON
To see all locations, 30 per page:

    http://localhost:8080/api/locations

To go the next page (the page parameter works for all API responses):

    http://localhost:8080/api/locations?page=2

Search for organizations by keyword and/or location:

    http://localhost:8080/api/search?keyword=food
    http://localhost:8080/api/search?keyword=counseling&location=94403
    http://localhost:8080/api/search?keyword=market&location=san mateo
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
`curl -s -D - http://ohanapi.herokuapp.com/api/search\?keyword\=shelter -o /dev/null`

Response Headers:

```
HTTP/1.1 200 OK
Cache-Control: max-age=0, private, must-revalidate
Content-Type: application/json
Date: Wed, 19 Feb 2014 14:16:40 GMT
Etag: "f104eaabf805bd034a7c376f15b66a4b"
Link: <http://ohanapi.herokuapp.com/api/search?keyword=shelter&page=3>; rel="last", <http://ohanapi.herokuapp.com/api/search?keyword=shelter&page=2>; rel="next"
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

Read more about [search](http://ohanapi.herokuapp.com/api/docs#!/api/GET_api_search_format_get_15) in the API docs.

### Tools
We recommend these tools to interact with APIs:

[JSONView](https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc) A Google Chrome extension for formatting the JSON response so it is easier to read in the browser.

[HTTPie](https://github.com/jkbr/httpie) command line utility for making interactions with web services from the command line more human friendly.

### Resetting the app
If you want to wipe out the local test DB and start from scratch:

    script/drop
    script/bootstrap

Do this on your local machine only, not in production!

### User authentication and emails
The app allows developers to sign up for an account via the home page (http://localhost:8080), but all email addresses need to be verified first. In development, the app sends email via Gmail. If you want to try this email process on your local machine, you need to configure your Gmail username and password by creating a file called `application.yml` in the config folder, and entering your info like so:

    GMAIL_USERNAME: your_email@gmail.com
    GMAIL_PASSWORD: your_password

`application.yml` is ignored in `.gitignore`, so you don't have to worry about exposing your credentials if you ever push code to GitHub. If you don't care about email interactions, but still want to try out the signed in experience, you can [sign in](http://localhost:8080/users/sign_in) with either of the users whose username and password are stored in [db/seeds.rb](https://github.com/smcgov/ohana-api-smc/blob/master/db/seeds.rb).


### Test the app
Run tests locally with this simple command:

    rspec

For faster tests:

    gem install zeus
    zeus start #in a separate Terminal window or tab
    zeus rspec spec

To see the actual tests, browse through the [spec](https://github.com/smcgov/ohana-api-smc/tree/master/spec) directory.

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
* by closing [issues](https://github.com/smcgov/ohana-api-smc/issues)
* by reviewing patches

## Submitting an Issue
We use the [GitHub issue tracker](https://github.com/smcgov/ohana-api-smc/issues) to track bugs and features. Before submitting a bug report or feature request, check to make sure it hasn't already been submitted. When submitting a bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any details that may be necessary to reproduce the bug, including your gem version, Ruby version, and operating system. Ideally, a bug report should include a pull request with failing specs.

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

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.