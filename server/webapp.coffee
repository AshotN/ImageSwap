express = require 'express'
config = require '../config'
app = require './express'
Couleurs = require('couleurs')(true);
db = require './db'
passport = require './passport'




User = db.models.User


app.get '/', (req, res) ->
	date = new Date()

	day = date.getDate()
	month = date.getMonth()+1
	year = date.getFullYear()

	date = month+"-"+day+"-"+year
	dateSlash = month+"/"+day+"/"+year
	res.render 'index', today: date, todayslash: dateSlash

app.get '/admin', (req, res) ->
	return res.redirect '/admin/login' unless req.user?
	res.render 'admin/index'

app.get '/admin/login', (req, res) ->
	if req.user 
		res.redirect '/admin/logout'
	res.render 'admin/login'

app.get 'admin/logout', (req, res) ->
	req.logout()
	res.redirect '/'

app.post '/admin/login', (req, res, next) ->
	#return res.status(500).json unless req.body
	User.count {}, (err, countout) ->
		#Need error handling
		count = countout
		if(count == 0)
			user = new User
				username: req.body.username
				password: req.body.password

			user.save (err, user) ->
				#Need error handling
				console.log "Admin Account Created"
				return res.render "admin/login", message: "Admin Account Created"
		else

			passport.authenticate('local', (err, user, info) ->
				return res.status(500).json err if err?
				req.logIn user, (err) ->
					console.log err
					return res.render "admin/login", message: "Incorrect Login" if err?
					return res.redirect "/admin/"

			) req, res, next


app.get '*', (req, res) ->
	res.render '404'

process.on "uncaughtException", (err) ->
	if err.errno is "EADDRINUSE"
		console.log("Port in use alerady".fg("#F00"))
	else
		console.log err
	return process.exit 1

