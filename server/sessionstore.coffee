session = require 'express-session'
sessionstore = require('connect-mongo')(session)
config = require '../config'

module.exports = new sessionstore
  url: config.session.db
