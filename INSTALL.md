# Running Ohana API on your computer

## Fork and clone

[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/ohana-api-smc.git && cd ohana-api-smc

[fork]: http://help.github.com/fork-a-repo/

## Docker Setup (recommended, especially for Windows users)

1. Download, install, and launch [Docker]

1. Set up the Docker image:

        $ script/bootstrap

1. Start the app:

        $ docker-compose up

Once the docker images are up and running, the app will be accessible at
[http://localhost:8080](http://localhost:8080).

### Verify the app is returning JSON

[http://localhost:8080/api/locations](http://localhost:8080/api/locations)

[http://localhost:8080/api/search?keyword=food](http://localhost:8080/api/search?keyword=food)

We recommend the [JSONView][jsonview] Google Chrome extension for formatting
the JSON response so it is easier to read in the browser.

[jsonview]: https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc

### More useful Docker commands

* Stop this running container: `docker-compose stop`
* Stop and delete the containers: `docker-compose down`
* Open a shell in the web container: `docker-compose run --rm web bash`

[Docker]: https://docs.docker.com/engine/installation/

## Local Setup

Before you can run Ohana API, you'll need to have the following software
packages installed on your computer: Git, PhantomJS, Postgres, Ruby 2.3+,
and RVM (or rbenv).
If you're on a Linux machine, you'll also need Node.js and `libpq-dev`.

If you don't already have all the prerequisites installed, there are two ways
you can install them:

- If you're on a Mac, the easiest way to install all the tools is to use
@monfresh's [laptop] script.

- Install everything manually: [Build tools], [Ruby with RVM], [PhantomJS],
[Postgres], and [Node.js][node] (Linux only).

[laptop]: https://github.com/monfresh/laptop
[Build tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[Ruby with RVM]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[PhantomJS]: https://github.com/jonleighton/poltergeist#installing-phantomjs
[Postgres]: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md

### PostgreSQL Accounts

On Linux, PostgreSQL authentication can be [set to _Trust_](http://www.postgresql.org/docs/9.1/static/auth-methods.html#AUTH-TRUST) [in `pg_hba.conf`](https://wiki.postgresql.org/wiki/Client_Authentication) for ease of installation. Create a user that can create new databases, whose name matches the logged-in user account:

    $ sudo -u postgres createuser --createdb --no-superuser --no-createrole `whoami`

On a Mac with Postgres.app or a Homebrew Postgres installation, this setup is
provided by default.

### Install the dependencies and populate the database with sample data:

    bin/setup

_Note: Installation and preparation can take several minutes to complete!_

### Run the app

Start the app locally on port 8080:

    puma -p 8080

### Verify the app is returning JSON

[http://localhost:8080/api/locations](http://localhost:8080/api/locations)

[http://localhost:8080/api/search?keyword=food](http://localhost:8080/api/search?keyword=food)

We recommend the [JSONView][jsonview] Google Chrome extension for formatting
the JSON response so it is easier to read in the browser.

[jsonview]: https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc

## Set up the environment variables & customizable settings

#### Configure environment variables
Inside the `config` folder, you will find a file named `application.yml`.
Read through it to learn how to customize it to suit your needs.

#### Adjust customizable settings
Inside the `config` folder, you will also find a file called `settings.yml`.
In that file, there are various settings you can customize. They are already
properly configured for San Mateo County data, but if you wish to make changes,
please read through the instructions in that file carefully.

To customize the text the appears throughout the website
(such as error messages, titles, labels, branding), edit `config/locales/en.yml`.
You can also translate the text by copying and pasting the contents of `en.yml`
into a new locale for your language. Find out how in the
[Rails Internationalization Guide](http://guides.rubyonrails.org/i18n.html).

### User and Admin authentication (for the developer portal and admin interface)

To access the developer portal, visit [http://developer.lvh.me:8080/](http://developer.lvh.me:8080/).

To access the admin interface, visit [http://admin.lvh.me:8080/](http://admin.lvh.me:8080/).

The app automatically sets up users and admins you can sign in with.
Their username and password are stored in [db/seeds.rb][seeds].

[seeds]: https://github.com/smcgov/ohana-api-smc/blob/master/db/seeds.rb

If you deleted these test users and admins, you can restore them by running
`script/users`.

The third admin in the seeds file is automatically set as a Super Admin. If you
would like to set additional admins as super admins, you will need to do it
manually for security reasons.

#### Setting an admin as a Super Admin

##### Locally:

    psql ohana_api_smc_development
    UPDATE "admins" SET super_admin = true WHERE email = 'masteradmin@ohanapi.org';
    \q

Replace `masteradmin@ohanapi.org` in the command above with the email of the
admin you want to set as a super admin.

##### On Heroku:
Follow the same steps above, but replace `psql ohana_api_smc_development` with
`heroku pg:psql -a ohana-api-smc`.
