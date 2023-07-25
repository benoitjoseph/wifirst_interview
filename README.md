# README

## Configuration (MacOS)

Puma must be built with OpenSSL 1.x on MacOS. If you have OpenSSL 3.x installed, specify the version using:

```
bundle config build.puma --with-pkg-config=$(brew --prefix openssl@1.1)/lib/pkgconfig
bundle install --redownload
```

