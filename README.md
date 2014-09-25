# RubyCAS-Server

## Beyond Z Customizations

The file lib/casserver/views/layout.erb has the login layout html. This is based on the main site, but it is modified, so must be maintained separately.

The public/ folder has image and css assets brought off the main site. These are simply downloaded from the production site and renamed - to do this, load the beyondz.org site in your browser, view source and find the link rel=styleshet near the top. Download that file and save it in here as public/beyondz.css. They do NOT need to be maintained separately at this time. Currently required are the logo, favicon, and stylesheet.

The file lib/beyondz.rb holds our authenticator. It uses a cooperative check_credentials http api on the public site to check against the main database. It is configured via config.yml for server (string), port (integer), ssl (boolean), and allow_self_signed (boolean) to know where to connect. The default ssl options is production-ready - it will verify certificates and use SSL. For development purposes, you may turn these options off with ssl: false.

## End user flow

The end user should always go to the service they want to use (portal.beyondz.org for example). The service then redirects them to the single sign on server, with a service parameter telling it to redirect them back once login is complete.

user goes to canvas -> canvas sends them to sso -> sso sends back to canvas

On the backend, the SSO server talks to the public site server and the service (canvas) server talks to the SSO server to validate login tickets. This should be SSL secured in production so the sso and canvas servers both need working client certificates, and the sso and public site servers need to be running https.

The user master record is stored on the public site. User records also need to exist on the service - so a bz.org and canvas user need to exist with the same email address for the login to succeed end to end.

## Copyright

Portions contributed by Matt Zukowski are copyright (c) 2011 Urbacon Ltd.
Other portions are copyright of their respective authors.

## Authors

See https://github.com/rubycas/rubycas-server/commits

## Installation

Example with mysql database:

1. `git clone git://github.com/rubycas/rubycas-server.git`
2. `cd rubycas-server`
3. `cp config/config.example.yml config.yml`
4. Customize your server by modifying the `config.yml` file. It is well commented but make sure that you take care of the following:
    1. Change the database driver to `mysql2`
    2. Configure at least one authenticator
    3. You might want to change `log.file` to something local, so that you don't need root. For example just `casserver.log`
    4. You might also want to disable SSL for now by commenting out the `ssl_cert` line and changing the port to something like `8888`
5. Create the database (i.e. `mysqladmin -u root create casserver` or whatever you have in `config.yml`)
6. Modify the existing Gemfile by adding drivers for your database server. For example, if you configured `mysql2` in config.yml, add this to the Gemfile: `gem "mysql2"`
7. Run `bundle install`
8. `bundle exec rubycas-server -c config.yml`

Your RubyCAS-Server should now be running. Once you've confirmed that everything looks good, try switching to a [Passenger](http://www.modrails.com/) deployment. You should be able to point Apache (or whatever) to the `rubycas-server/public` directory, and everything should just work.

Some more info is available at the [RubyCAS-Server Wiki](https://github.com/rubycas/rubycas-server/wiki).

If you have questions, try the [RubyCAS Google Group](https://groups.google.com/forum/?fromgroups#!forum/rubycas-server) or #rubycas on [freenode](http://freenode.net).

## License

RubyCAS-Server is licensed for use under the terms of the MIT License.
See the LICENSE file bundled with the official RubyCAS-Server distribution for details.
