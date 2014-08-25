#Ohana API

[![Build Status](https://travis-ci.org/codeforamerica/ohana-api.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-api) [![Coverage Status](https://coveralls.io/repos/codeforamerica/ohana-api/badge.png?branch=master)](https://coveralls.io/r/codeforamerica/ohana-api) [![Dependency Status](https://gemnasium.com/codeforamerica/ohana-api.svg)](https://gemnasium.com/codeforamerica/ohana-api)

This is the API + Admin Interface portion of the [Ohana API](http://ohanapi.org) project, an open source community resource platform developed by [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) during their Code for America Fellowship in 2013, in partnership with San Mateo County's Human Services Agency. Ohana makes it easy for communities to publish a database of social services, and allows developers to build impactful applications that serve underprivileged residents.

Before we started working on the Ohana API, the search interface that residents and social workers in San Mateo County had access to was the Peninsula Library System's [CIP portal](http://catalog.plsinfo.org:81/). As a demonstration of the kind of applications that can be built on top of the Ohana API, we developed a [better search interface](http://smc-connect.org) ([repo link](https://github.com/codeforamerica/ohana-web-search)) that consumes the API via our [Ruby wrapper](https://github.com/codeforamerica/ohanakapa).

## Stack Overview

* Ruby version 2.1.1
* Rails version 4.1.4
* Postgres
* Testing Frameworks: RSpec, Factory Girl, Capybara

## Demo
You can see a running version of the different parts of the application here:

**Developer portal**: [http://ohana-api-demo.herokuapp.com/](http://ohana-api-demo.herokuapp.com/) (see [db/seeds.rb][seeds] for a list of usernames and passwords you can sign in with.)

**API**: [http://ohana-api-demo.herokuapp.com/api](http://ohana-api-demo.herokuapp.com/api)

**Admin Interface**: [http://ohana-api-demo.herokuapp.com/admin](http://ohana-api-demo.herokuapp.com/admin) (see [db/seeds.rb][seeds] for a list of usernames and passwords you can sign in with.)

[seeds]: https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb

## Current Status
We are happy to announce that this project has been awarded a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), which means we get to keep working on it in 2014! Our primary goals this year are: simplifying the installation process, streamlining the code, reducing dependencies, and preparing the project for broader installation by a variety of organizations and governments.

## Data Schema
If you would like to try out the current version of the project, please read the Wiki article about [Populating the Postgres DB from a JSON file](https://github.com/codeforamerica/ohana-api/wiki/Populating-the-Postgres-database-from-a-JSON-file). That article documents the current schema and data dictionary, but please note that this will be in flux as we are working with various interested parties to define a [Human Services Data Specification](https://github.com/codeforamerica/OpenReferral).

## API documentation
[http://ohanapi.herokuapp.com/api/docs](http://ohanapi.herokuapp.com/api/docs)

[Search documentation](http://ohanapi.herokuapp.com/api/docs#!/search/GET_api_search_format_get_0)

## Client libraries

- Ruby: [Ohanakapa][ohanakapa] (our official wrapper)

We would love to see libraries for other programming languages.
If you've built one, let us know and we'll add it here.

[ohanakapa]: https://github.com/codeforamerica/ohanakapa

## Taxonomy
By default, this project uses the [Open Eligibility](http://openeligibility.org) taxonomy to assign Services to [Categories](https://github.com/codeforamerica/ohana-api/blob/master/app/models/category.rb).
If you would like to use your own taxonomy, feel free to update this rake task to [create your own hierarchy or tree structure](https://github.com/codeforamerica/ohana-api/blob/master/lib/tasks/oe.rake). Then run `rake create_categories`.

The easiest way to assign categories to a service is to use the Admin interface. Here's a screenshot:

![Editing categories in Ohana API Admin](https://github.com/codeforamerica/ohana-api/raw/master/categories-in-ohana-api-admin.png)

## Apps that are using the Ohana API
[SMC-Connect](http://www.smc-connect.org)
[GitHub repo for SMC-Connect](https://github.com/codeforamerica/human_services_finder)

[Ohana API Admin site](https://github.com/codeforamerica/ohana-api-admin)

[Ohana SMS](https://github.com/marks/ohana-sms)


## Deploying to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

See the [Wiki](https://github.com/codeforamerica/ohana-api/wiki/How-to-deploy-the-Ohana-API-to-your-Heroku-account) for manual setup or use the one-click deploy button above.

## Local Installation

Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md

## Running the tests

Run tests locally with this simple command:

    script/test

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-api/tree/master/spec) directory.

## Contributing

We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/codeforamerica/ohana-api/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/codeforamerica/ohana-api) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.