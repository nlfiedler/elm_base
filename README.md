# ElmBase

## Initial Build

### Steps

1. Install [Elixir](http://elixir-lang.org)
1. Install [Hex](https://hex.pm): `mix local.hex`
1. Install [Phoenix](http://www.phoenixframework.org) 1.2 generator: `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`
1. Create the Phoenix app: `mix phoenix.new elm_base`

### Database Setup

Slightly unconventional database setup just because of my environment. In your case, just make sure you have [PostgreSQL](https://www.postgresql.org) installed and running.

```
$ brew install postgresql
$ initdb -D postgres
$ pg_ctl -D postgres -l logfile start
$ psql postgres
postgres=# CREATE ROLE postgres LOGIN CREATEDB;
CREATE ROLE
postgres=# \q
```

### Prepare the Application

```
$ cd elm_base
$ mix deps.get
$ mix ecto.create
$ mix ecto.migrate
$ npm install
$ mix phoenix.server
```
