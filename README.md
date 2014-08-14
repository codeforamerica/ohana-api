[![Build Status](https://travis-ci.org/smcgov/ohana-api-smc.png?branch=master)](https://travis-ci.org/smcgov/ohana-api-smc) [![Coverage Status](https://coveralls.io/repos/smcgov/ohana-api-smc/badge.png?branch=master)](https://coveralls.io/r/smcgov/ohana-api-smc) [![Dependency Status](https://gemnasium.com/smcgov/ohana-api-smc.svg)](https://gemnasium.com/smcgov/ohana-api-smc)

#Ohana API - San Mateo County

This is the API + Admin Interface portion for the San Mateo County instance of the [Ohana API](http://ohanapi.org). The API exposes information about community resources in San Mateo County to make it easier for residents in need to find services they are eligible for.

## Apps that are using the Ohana API in San Mateo County
[SMC-Connect](http://www.smc-connect.org), a mobile-friendly website for looking up community and human services. ([GitHub repo for SMC-Connect](https://github.com/smcgov/SMC-Connect))

We encourage third-party developers to build additional applications on top of the API. You can register your app on our [developer portal](http://ohanapi.herokuapp.com) (branding work in progress), and view the [API documentation](http://ohanapi.herokuapp.com/api.docs).

## Taxonomy
We are currently using the [Open Eligibility](http://openeligibility.org) taxonomy to assign Services to [Categories](https://github.com/smcgov/ohana-api-smc/blob/master/app/models/category.rb).
Ohana API only accepts the categories defined by Open Eligibility.

The easiest way to assign categories to a service is to use the Admin interface. Here's a screenshot:

![Editing categories in Ohana API Admin](https://github.com/codeforamerica/ohana-api/raw/master/categories-in-ohana-api-admin.png)

## API documentation
[http://ohanapi.herokuapp.com/api/docs](http://ohanapi.herokuapp.com/api/docs)

[Search documentation](http://ohanapi.herokuapp.com/api/docs#!/api/GET_api_search_format_get_15)

## Ruby wrapper
[https://github.com/codeforamerica/ohanakapa](https://github.com/codeforamerica/ohanakapa)

## Stack Overview

* Ruby version 2.1.1
* Rails version 4.1.4
* Postgres
* Redis
* Testing Frameworks: RSpec, Factory Girl, Capybara

## Local Installation

Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/smcgov/ohana-api-smc/blob/master/INSTALL.md

### Running the tests

Run tests locally with this simple command:

    script/test

To see the actual tests, browse through the [spec](https://github.com/smcgov/ohana-api-smc/tree/master/spec) directory.

## Contributing

We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/smcgov/ohana-api-smc/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/smcgov/ohana-api-smc) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.