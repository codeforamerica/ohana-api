#Ohana API

[![Build Status](https://travis-ci.org/codeforamerica/ohana-api.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-api) [![Coverage Status](https://coveralls.io/repos/codeforamerica/ohana-api/badge.png?branch=master)](https://coveralls.io/r/codeforamerica/ohana-api) [![Dependency Status](https://gemnasium.com/codeforamerica/ohana-api.svg)](https://gemnasium.com/codeforamerica/ohana-api) [![Code Climate](https://codeclimate.com/github/codeforamerica/ohana-api.png)](https://codeclimate.com/github/codeforamerica/ohana-api)

Ohana API is a Ruby on Rails application that makes it easy for communities to publish and maintain a database of social services, and allows developers to build impactful applications that serve underprivileged residents.

This is the API + Admin Interface portion of the [Ohana API](http://ohanapi.org) project, developed by [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) during their Code for America Fellowship in 2013, in partnership with San Mateo County's Human Services Agency.

The Ohana project also comes with a [web-based search interface](https://github.com/codeforamerica/ohana-web-search) that allows anyone to easily find services that are available in a particular community.

## Development Road Map for 2014
As a winner of the Knight News Challenge (Health edition), the Ohana project received a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), which allowed us to improve the project, and prepare it for broader installation by a variety of organizations and governments.

We've fulfilled most of the deliverables defined in our agreement with the Knight Foundation, which ends in January 2015. Our remaining tasks are listed in the [Issues](https://github.com/codeforamerica/ohana-api/issues) section of this repo.

Please note that between now and January 2015, there could be breaking changes in the API as we update it to support the [OpenReferral spec](https://github.com/codeforamerica/OpenReferral). The spec is currently at version 0.8, and version 1.0 is scheduled to be released by late January 2015.

## Stack Overview

* Ruby version 2.1.5
* Rails version 4.1.8
* Postgres
* Testing Frameworks: RSpec, Factory Girl, Capybara

## Local Installation

Follow the instructions in [INSTALL.md][install] to get the app up and running, and to learn how to import your data.

[install]: https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md

## Demo
You can see a running version of the different parts of the application here:

**Developer portal**: [http://ohana-api-demo.herokuapp.com/](http://ohana-api-demo.herokuapp.com/)
(see [db/seeds.rb][developer_portal_seeds] for two usernames and passwords you can sign in with).

**API**: [http://ohana-api-demo.herokuapp.com/api](http://ohana-api-demo.herokuapp.com/api)

**Admin Interface**: [http://ohana-api-demo.herokuapp.com/admin](http://ohana-api-demo.herokuapp.com/admin)
(see [db/seeds.rb][admin_interface_seeds] for three usernames and passwords you can sign in with).

[developer_portal_seeds]: https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb#L10-L23
[admin_interface_seeds]: https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb#L25-45

## API documentation (work in progress)
[http://codeforamerica.github.io/ohana-api-docs/](http://codeforamerica.github.io/ohana-api-docs/)

As the API is updated to match the [OpenReferral specification](https://github.com/codeforamerica/OpenReferral), the
documentation will be updated as well. Version 1.0 of the spec is scheduled
to be released by the end of January 2015.

## Client libraries

- Ruby: [Ohanakapa][ohanakapa] (our official wrapper)

We would love to see libraries for other programming languages.
If you've built one, let us know and we'll add it here.

[ohanakapa]: https://github.com/codeforamerica/ohanakapa

## Taxonomy
Out of the box, this project supports the [Open Eligibility](http://openeligibility.org)
taxonomy. If you would like to use your own taxonomy, or add more categories to
the Open Eligibility taxonomy, read our Wiki article on [taxonomy basics](https://github.com/codeforamerica/ohana-api/wiki/Taxonomy-basics).

## Deploying to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

See the [Wiki](https://github.com/codeforamerica/ohana-api/wiki/How-to-deploy-the-Ohana-API-to-your-Heroku-account) for manual setup or use the one-click deploy button above.

## Running the tests

Run tests locally with this simple command:

    script/test

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-api/tree/master/spec) directory.

## Contributing

We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/codeforamerica/ohana-api/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.
