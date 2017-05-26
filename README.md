# ElmBase

The purpose of this project is to demonstrate the process of adding [Elm](http://elm-lang.org) to a [Phoenix](http://www.phoenixframework.org) web application, and then migrating from the Phoenix 1.2 layout to the new 1.3 layout. And most importantly, with [elm-brunch](https://github.com/madsflensted/elm-brunch) correctly configured for the new layout.

## Initial Build

### Prerequisites

1. Install [Elixir](http://elixir-lang.org)
1. Install [Hex](https://hex.pm): `mix local.hex`
1. Install [Phoenix](http://www.phoenixframework.org) 1.2 generator: `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`
1. Install [Node](https://nodejs.org/)

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
$ mix phoenix.new elm_base
$ cd elm_base
$ mix deps.get
$ mix ecto.create
$ mix ecto.migrate
$ npm install
$ mix phoenix.server
```

Visit http://localhost:4000 to ensure the standard page is displayed.

## Introducing Elm

There are [blog](http://www.cultivatehq.com/posts/phoenix-elm-1/) [posts](https://medium.com/@diamondgfx/writing-a-full-site-in-phoenix-and-elm-a100804c9499#.47kj8oe42) and [examples](https://github.com/bigardone/phoenix-and-elm) that cover basically this same recipe. I used slightly different paths here, since I feel that Elm is more akin to JavaScript than it is to Elixir, so I put the Elm code next to the other client-side assets. Also, I put the Elm code inside a `src` directory, since that seems to be a reasonable convention.

```
$ mkdir -p web/static/elm/src
$ cd web/static/elm
$ elm-package install -y
```

Create `web/static/elm/src/Main.elm` with a basic `Html.text` "hello world" style message.

Edit `source-directories` in `elm-package.json`, changing `.` to `src` as mentioned above.

Install the elm-brunch plugin because it saves effort in the development cycle:

```
$ cd ../../..
$ npm i --save-dev elm-brunch
```

Add the following under `plugins` in `brunch-config.js`:

```
elmBrunch: {
  elmFolder: "web/static/elm",
  mainModules: ["src/Main.elm"],
  outputFolder: "../vendor"
},
```

The `outputFolder` setting, which is relative to the `elmFolder` path, is `vendor` for several reasons. First, it is automatically compiled and included before the `app.js` code. Second, there is no need to `require` or `import` the Elm generated JavaScript in `app.js` in order to use it. While it is possible to use the other approach, the first time `brunch build` is run, it produces an error with regards to the `import` of the JavaScript file that does not yet exist.

Replace the "marketing" `div` in `index.html.eex` with the following (partly just to eliminate some boilerplate, and also to keep the tests working with minimal changes):

```
<div id="elm-main"></div>
```

Add to, or replace entirely, the `web/static/js/app.js` with the following:

```
const elmDiv = document.getElementById('elm-main');
if (elmDiv) {
    Elm.Main.embed(elmDiv);
}
```

Run `node node_modules/.bin/brunch build` to make sure everything builds.

Run `mix phoenix.server` and make sure "Hello from Elm" appears on the web page.

## Switch to Phoenix 1.3 layout

Follow the steps as described in Chris McCord's migration [guide](https://gist.github.com/chrismccord/71ab10d433c98b714b75c886eff17357), with some additional notes.

1. Fixed a few additional paths in `brunch-config.js`, mostly around `web/static`.
1. Add `"elm"` to the `paths.watched` in `brunch-config.js` since the `elm` directory is not in any of the `watched` folders after the layout change.
1. Go through the comments and make sure to apply any relevant errata.

### Make Sure It Works

```
$ rm -rf _build deps
$ mix deps.get
$ mix compile
$ mix test
$ cd assets
$ npm install
$ node node_modules/.bin/brunch build
$ cd ..
$ mix phx.server
```

Visit http://localhost:4000 to ensure you see the expected message from Elm. Bonus points if you check your browser's developer console for any errors.
