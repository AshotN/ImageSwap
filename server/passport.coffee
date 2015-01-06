mongoose = require 'mongoose'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

config = require '../config'
db = require './db'

User = db.models.User

handleLogin = (username, password, cb) ->
  console.log 1, username, password
  User.findOne username: username, (err, user) ->
    console.log 2, err, user
    return cb err if err?
    return cb null, false unless user?
    user.comparePassword password, (err, match) ->
      console.log 3, err, match
      return cb err if err?
      return cb null, false, message: 'Invalid password' unless match
      return cb null, user

strategy = new LocalStrategy handleLogin

passport.use strategy

passport.serializeUser (user, cb) ->
  console.log 4, user
  cb null, user._id

passport.deserializeUser (id, cb) ->
  console.log 5, id
  User.findOne _id: id, (err, doc) ->
    console.log 6, err, doc
  User.findOne {_id: id}, cb



module.exports = passport
