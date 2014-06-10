# Running Ohana API on your computer

## Install Prerequisites

Before you can run Ohana API, you'll need to have the following software
packages installed on your computer: Git, Ruby 2.1+, RVM, Postgres, and Redis.
If you're on a Linux machine, you'll also need Node.js and libpq-dev.

If you already have all of the prerequisites installed, you can go straight
to the [Ohana Installation](#install-ohana-api). Otherwise, there are two ways
you can install the tools:

1. Use our Vagrant [virtual machine][dev-box], which has everything set up for
you. This is the recommended method for Windows users.

[dev-box]: https://github.com/codeforamerica/ohana-api-dev-box

2. Install everything manually: [Build tools][build-tools], [Ruby with RVM][ruby],
[Postgres][postgres], [Redis][redis], and [Node.js][node] (Linux only).

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[postgres]: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
[redis]: https://github.com/codeforamerica/ohana-api/wiki/Installing-Redis
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md

### PostgreSQL Accounts

On Linux, PostgreSQL authentication can be [set to _Trust_](http://www.postgresql.org/docs/9.1/static/auth-methods.html#AUTH-TRUST) [in `pg_hba.conf`](https://wiki.postgresql.org/wiki/Client_Authentication) for ease of installation. Create a user that can create new databases, whose name matches the logged-in user account:

    $ sudo -u postgres createuser --createdb --no-superuser --no-createrole `whoami`

On Mac with Postgres.app, this setup is provided by default.

## Install Ohana API

### Fork and clone

[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/ohana-api-smc.git && cd ohana-api-smc

[fork]: http://help.github.com/fork-a-repo/

### Install the dependencies and populate the database with sample data:

    script/bootstrap

_Note: Installation and preparation can take several minutes to complete!_

### Set up the environment variables & customizable settings

Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml`.

Inside the `config` folder, you will also find a file called `settings.yml`.
In that file, there are 4 variables you can customize. They are already
properly configured for San Mateo County data, but if you wish to make changes,
please read through the instructions in that file carefully.

### Run the app

Start the app locally on port 8080:

    rails s -p 8080

If for some reason, you can't run on port 8080, make sure you update
`API_BASE_URL` and `API_BASE_HOST` in `config/application.yml` if you change
the port number. You'll also need to update the port number in
`OHANA_API_ENDPOINT` in your local [Admin Interface][admin] if it's pointing to
your local API.

[admin]: https://github.com/smcgov/SMC-Connect-Admin

### Verify the app is returning JSON

[http://localhost:8080/api/locations](http://localhost:8080/api/locations)

[http://localhost:8080/api/search?keyword=food](http://localhost:8080/api/search?keyword=food)

We recommend the [JSONView][jsonview] Google Chrome extension for formatting
the JSON response so it is easier to read in the browser.

[jsonview]: https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc

### Reset the database with clean data

To reset your local database and populate it again with clean data:
```
script/reset
```

### User authentication (for the developer portal)

The app automatically sets up users you can [sign in][sign_in] with.
Their username and password are stored in [db/seeds.rb][seeds].

[sign_in]: http://localhost:8080/users/sign_in
[seeds]: https://github.com/codeforamerica/ohana-api/blob/master/db/seeds.rb

