# License Check

Check your project dependencies licenses and verify if you are using a forbidden license for commercial usage.

## 🚀 Usage Example

Use the already built image from my Dockerhub

```shell
docker run -it -v /some/dir/hoge-project:/code fhaze/license-check
```

> Replace `/some/dir/hoge-project` with your project absolute directory

or build it yourself

```shell
docker build . -t license-check
docker run -it -v /some/dir/hoge-project:/code license-check
```

## 💬 Supported package managers
- [Golang](https://go.dev/doc/modules/managing-dependencies)
- [Python3.8](https://packaging.python.org/en/latest/tutorials/installing-packages/) (using requirements.txt or Pyfile)
- [npm](https://docs.npmjs.com/about-npm)
- [Conan](https://conan.io/) (C/C++)

## 📦 Supported output formats
- table (default)
- json
- csv

> Change the output by setting `-e FORMAT=table|json|csv` to the `docker run` command

Default output example (`FORMAT=table`)

```shell
$ docker run -e FORMAT=table -it -v /some/dir/hoge-project:/code fhaze/license-check
Name                               Version                             License       Check
---------------------------------  ----------------------------------  ------------  -------
github.com/klauspost/compress      v1.13.6                             Apache-2.0    OK
github.com/xdg-go/pbkdf2           v1.0.0                              Apache-2.0    OK
github.com/xdg-go/scram            v1.0.2                              Apache-2.0    OK
github.com/xdg-go/stringprep       v1.0.2                              Apache-2.0    OK
go.mongodb.org/mongo-driver        v1.8.3                              Apache-2.0    OK
github.com/pkg/errors              v0.9.1                              BSD-2-Clause  OK
github.com/golang/snappy           v0.0.1                              BSD-3-Clause  OK
golang.org/x/crypto                v0.0.0-20210817164053-32db794688a5  BSD-3-Clause  OK
golang.org/x/net                   v0.0.0-20210913180222-943fd674d43e  BSD-3-Clause  OK
golang.org/x/sync                  v0.0.0-20190911185100-cd5d95a43a6e  BSD-3-Clause  OK
golang.org/x/sys                   v0.0.0-20211103235746-7861aae1554b  BSD-3-Clause  OK
golang.org/x/text                  v0.3.7                              BSD-3-Clause  OK
golang.org/x/time                  v0.0.0-20201208040808-7e3f01d25324  BSD-3-Clause  OK
github.com/go-stack/stack          v1.8.0                              MIT           OK
github.com/golang-jwt/jwt          v3.2.2+incompatible                 MIT           OK
github.com/labstack/echo/v4        v4.6.3                              MIT           OK
github.com/labstack/gommon         v0.3.1                              MIT           OK
github.com/mattn/go-colorable      v0.1.11                             MIT           OK
github.com/mattn/go-isatty         v0.0.14                             MIT           OK
github.com/sirupsen/logrus         v1.8.1                              MIT           OK
github.com/valyala/bytebufferpool  v1.0.0                              MIT           OK
github.com/valyala/fasttemplate    v1.2.1                              MIT           OK
github.com/youmark/pkcs8           v0.0.0-20181117223130-1be2e3e5546d  MIT           OK
```
