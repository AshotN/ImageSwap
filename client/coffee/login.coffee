$(document).ready ->
	socket = io()

	$("#submitlogin").click (e) ->
		e.preventDefault()
		data = $("#loginform").serializeArray()
		socket.emit('login', data)