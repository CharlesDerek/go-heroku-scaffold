
# go-heroku-scaffold

A barebones Go app, which can easily be deployed to Heroku in seconds.

This application supports the [Getting Started with Go on Heroku](https://devcenter.heroku.com/articles/getting-started-with-go) article, including the [original repository from heroku](https://github.com/heroku/go-getting-started).


## Running Locally (untested):

Make sure you have [Go](http://golang.org/doc/install) version 1.17 or newer and the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed.

```sh
$ git clone https://github.com/heroku/go-getting-started.git
$ cd go-getting-started
$ go build -o bin/go-getting-started -v . # or `go build -o bin/go-getting-started.exe -v .` in git bash
github.com/mattn/go-colorable
gopkg.in/bluesuncorp/validator.v5
golang.org/x/net/context
github.com/heroku/x/hmetrics
github.com/gin-gonic/gin/render
github.com/manucorporat/sse
github.com/heroku/x/hmetrics/onload
github.com/gin-gonic/gin/binding
github.com/gin-gonic/gin
github.com/heroku/go-getting-started
$ heroku local
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

## Deploying to Heroku (manually):

```sh
$ heroku create
$ git push heroku main
$ heroku open
```

or

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


## Scaffold Documentation:

    [ ]: Give the scaffold appropriate permissions:
        ```sudo chmod +x ./build.sh```
    [ ]: Run the scaffold:
        ```./build.sh```
    [ ]: Provide the scaffold with your signed in github username.
    [ ]: At [github.com/new](https://github.com/new) create a new repository, taking note of the repository name.
    [ ]: Provide the scaffold with the name of the repository name on github you just created.
    [ ]: Sit back and let the scaffold do the rest.


## Other information:

For more information about using Go on Heroku, see these Dev Center articles:

- [Go on Heroku](https://devcenter.heroku.com/categories/go)
