path = require 'path'
stylus = require 'stylus'
express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'

config = require '../config'
passport = require './passport'
sessionStore = require './sessionstore'


app = express()
app.disable 'x-powered-by'

app.use express.static path.resolve __dirname, '../client'
app.set 'views', path.resolve __dirname, '../views'
app.set 'view engine', 'jade'


app.use bodyParser()
app.use cookieParser config.session.secret

app.use session
  store: sessionStore
  key: config.session.key
  secret: config.session.secret
  cookie:
    maxAge: new Date(Date.now() + 36000000000)
    expires: new Date(Date.now() + 36000000000)

app.use passport.initialize()
app.use passport.session()


#console.log 5, sessionStore.db
module.exports = app





