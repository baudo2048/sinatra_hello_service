# sinatra_hello_service
Demonstration of a pattern for services on heroku using Sinatra

## references
http://blog.carbonfive.com/2014/04/28/micromessaging-connecting-heroku-microservices-wredis-and-rabbitmq/
https://silkandspinach.net/2014/08/31/sinatraheroku-microservices/
http://stackoverflow.com/questions/4525482/in-sinatraruby-how-should-i-create-global-variables-which-are-assigned-values
http://blog.markwatson.com/2011/11/ruby-sinatra-web-apps-with-background.html
http://stackoverflow.com/questions/14388263/is-a-global-variable-defined-inside-a-sinatra-route-shared-between-requests

## Interesting files
* config.ru - 
* procfile - 
* config/puba.rb

## Heroku setup

### create two apps tied to the same git repo, but with separate git repos on heroku, with two remote names
$ heroku create --remote mainapp
$ heroku create --remote servapp

### Set config variables to connect things together
$ heroku config:set WHICH_APP=mainapp --remote mainapp
$ heroku config:set WHICH_APP=servapp --remote servapp
$ heroku config:set MAINAPP_URL=xxx --remote servapp
$ heroku config:set SERVAPP_URL=xxx --remote mainapp


### Launch each one by pushing
$ git push mainapp main
$ git push servapp main

# Push when not working on main branch
$ git push mainapp main:mybranch
$ git push servapp main:mybranch

# Databases
$ heroku addons:create heroku-postgresql:hobby-dev -r mainapp
$ heroku addons:attach <pg dyno name> -r servapp
$ heroku addons:attach <pg dyno name> -r mainapp

## Migration
$ heroku run rake db:migrate -r mainapp

# Other Addons
$ heroku addons:create papertrail:choklad -r mainapp

### Handy commands:
* Update code: `git add --all; git commit -m "wip"; git push mainapp main; git push servapp main`
* Look at logss: `heroku logs --remote mainapp -t`


