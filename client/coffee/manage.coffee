$(document).ready ->

	socket = io()

	showMessage = (message, error = false, timeout=60000) ->

		if $("#messagetext").html() != message #
			console.log "Remve"
			$("#message").remove()


		if $("#message").length == 0 #Doesn't exist, make it
			$("body").append("<div id='message'><div id='messagetext'></div></div>")

		console.log "ERROR!" if error
		#IF error or not
		if error and not $("#message").hasClass("error")
			$("#message").addClass "error"	if error
		if not error and $("#message").hasClass("error")
			$("#message").removeClass("error")


		#Show
		$("#messagetext").html message
		$("#message").css "display", "block"
		$("#message").animate
			opacity: "1"
		, 700, ->
			$("#message").delay(timeout).animate
				opacity: "0"
			, 700, ->
				$("#message").css "display", "none"


	for i in [0...allImages.length]
		allImages[i].title = "<img class='qtip-image' src='../../img/images/#{name}'>"
		allImages[i].start = allImages[i].date;
		delete allImages[i].date;
	
	console.log allImages

	$("#calendar").fullCalendar
		height: 1100
		editable: true
		allDayDefault: true
		eventOverlap: false
		timeFormat: 'H(:mm)'
		eventSources: [
			allImages
		]


		eventRender: (event, element) ->
			console.log event
			element.find('.fc-title').html("<img class='calendar-image' src='../../img/images/#{event.name}'>");

		eventDrop: (event, delta, evertFunc) ->
			console.log 1, event
			newDate = moment(event.start.format(), 'YYYY-MM-DD').format('M/D/YYYY')
			console.log  event.name + " was dropped on " + event.start.format()
			console.log newDate
			socket.emit "dateModify", fileName: event.name, newDate: newDate, (result) ->
				if !result.status
					showMessage "Failed: " + result.message, true, 5000
				else
					showMessage result.message, false, 1000



		#eventAfterRender: (event, element) ->
		#	element.find('.fc-title').html("a<img class='qtip-image' src='../../img/images/#{event.name}'>");

	socket.on 'connect_error', (socket) ->
		console.log "NOO"
		showMessage("Lost Connection To Server", true, 60000)
		$("#upload").prop('disabled', true);


	socket.on 'connect', (socket) ->
		console.log "CONNECTED!"
		
	socket.on 'reconnect', (socket) ->
		console.log "RECONNECTEd"
		showMessage("Connected", false, 1000)
		$("#upload").prop('disabled', false);

