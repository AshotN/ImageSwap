config = require '../config'
sessionStore = require './sessionstore'
server = require './httpserver'

io = require('socket.io')(server, 'connect timeout':5000)
db = require './db'
fs = require 'fs'
crypto = require('crypto');

passport = require './passport'

#http://stackoverflow.com/a/21196961/1009167
ensureExists = (path, mask = 0o744, cb) ->
  fs.mkdir path, mask, (err) ->
    if err
      if err.code is "EEXIST" # ignore the error if the folder already exists
        cb null
      else # something else went wrong
        cb err
    else # successfully created folder
      cb null
    return


io.on 'connection', (socket) ->
	socket.on 'imageupload', (data, cb) ->
		
		data.images.forEach (item, count) ->
			if(item?)
				d = new Date(item[1])
				#Validate Name
				if Object.prototype.toString.call(d) == "[object Date]" 
					if isNaN d.getTime()
						return cb status: false, message: "Invaid Date"
				else
					return cb status: false, message: "Invalid Date" 
				name = item[1].split("/").join("-");
				ensureExists 'client/img/images', 0o744, (err) ->
					if(err?)
						return cb status: false, message: "Failed Too Create Image Folder"
					writedata = item[0].replace(/^data:image\/jpeg;base64,/, "");
					fs.writeFile "client/img/images/"+name+'.jpg', writedata, 'base64', (err) ->
		        #Error handlig maybe?
		        if(err?)
		          console.log 1, err
		          return cb status: false, message: "Failed To Write Image File!"
		      	return cb status: true, message: "Image(s) Uploaded"

      
