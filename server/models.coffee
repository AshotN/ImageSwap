mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

User = new mongoose.Schema
  username:
    type: String
    required: true
    unique: true
  password:
    type: String
    required: true

User.pre 'save', (next) ->
  return next() unless @.isModified 'password'
  bcrypt.genSalt 10, (err, salt) =>
    return next err if err?
    bcrypt.hash @password, salt, (err, hash) =>
      console.log err
      return next err if err?
      @password = hash
      next()


User.methods.comparePassword = (password, cb) ->
  bcrypt.compare password, @password, (err, match) ->
    return cb err if err?
    console.log 8, match
    cb null, match


User.set 'autoindex', false
exports.User = mongoose.model 'User', User
