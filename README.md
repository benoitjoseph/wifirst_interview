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
