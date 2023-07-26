# README

## Configuration (MacOS)

Puma must be built with OpenSSL 1.x on MacOS. If you have OpenSSL 3.x installed, specify the version using:

```
bundle config build.puma --with-pkg-config=$(brew --prefix openssl@1.1)/lib/pkgconfig
bundle install --redownload
```

## Local development

This project has been built with ESBundle and Bootstrap.
To run it, start the Procfile using:

```
bin/dev
```

To test the API, generate an access token:

```
user = User.first
user.access_token
```

then send a request using:

```
curl --location -g --request GET 'http://localhost:3000/api/cities/average_temperature?accuweather_keys[]=2123173&accuweather_keys[]=133788&accuweather_keys[]=334472' \
--header 'Authorization: Bearer <your access token>'
```

## Motivation

Whenever possible, I implemented a caching mechanism to avoid busting the 50 req/day rate limit.
Daily forecasts are expired after 30 minutes, after which they are automatically updated when needed.

I used the [u-case](https://github.com/serradura/u-case) gem that I recently tested and had a very nice experience with it. It provides a collection of Service Object wrappers and allow composition of services. It seemed appropriate, especially to handle the data refreshes (for instance, see [bookmarks_controller](https://github.com/benoitjoseph/wifirst_interview/blob/main/app/controllers/authenticated/bookmarks_controller.rb#L8-L9))

I tried to follow a `<resource>/<verb>/<service>` format when dealing with my service objects, for instance `Cities::Fetch::Service.call()`. The motivation behind this idea is that there may be cases where a service is only used by one other service, in which case it would make sense for it to belong in the same namespace.
In retrospect, a `<resource>/<verb>` pattern may have been better (such as `Cities::Fetch.call()`)

The authentication module is built on top of Rails' `has_secure_password` because I assumed using Devise was not part of the assignment. HTML Controllers are using the session and the API controllers are using access tokens (using the [jwt](https://github.com/jwt/ruby-jwt) gem)

Front-wise, I used Bootstrap with a very minimal theming. Forms are sent using HTML or TURBO_STREAM formats.
