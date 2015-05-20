express = require 'express'
config = require '../config'
app = require './express'
Couleurs = require('couleurs')(true);
db = require './db'
passport = require './passport'




User = db.models.User
Image = db.models.Image

app.get '/', (req, res) ->
	date = new Date()

	day = date.getDate()
	month = date.getMonth()+1
	year = date.getFullYear()

	date = month+"/"+day+"/"+year

	Image.findOne {'date': date}, (err, item) ->
		return res.status(500).json err if err?
		if item?
			return res.render 'index', today: date, image: item.name, user: req.user?
		return res.render 'index', today: date, user: req.user?
		
#########
# Admin #
#########

app.get '/admin', (req, res) ->
	return res.redirect '/admin/login' unless req.user?
	res.render 'admin/index'

app.get '/admin/manage', (req, res) ->
	return res.redirect '/admin/login' unless req.user?

	Image.find {},{_id: 0, name: 1, date: 1}, (err, item) ->
		res.render 'admin/manage', allImages: item


app.get '/admin/login', (req, res) ->
	if req.user 
		res.redirect '/admin/logout'
	res.render 'admin/login'

app.get '/admin/logout', (req, res) ->
	req.logout()
	res.redirect '/'

app.post '/admin/login', (req, res, next) ->
	#return res.status(500).json unless req.body
	User.count {}, (err, countout) ->
		return res.render "admin/login", message: "Error Occured: Failed to Get User Count" if err?
		count = countout
		if(count == 0)
			user = new User
				username: req.body.username
				password: req.body.password

			user.save (err, user) ->
				return res.render "admin/login", message: "Error Occured: Failed To Create User" if err?
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
	res.status(404).render '404'

process.on "uncaughtException", (err) ->
	if err.errno is "EADDRINUSE"
		console.log("Port in use alerady".fg("#F00"))
	else
		console.log err
	return process.exit 1

