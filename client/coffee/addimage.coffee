$(document).ready ->
	socket = io()
	picker = ""

	date = new Date()

	day = date.getDate()
	month = date.getMonth()+1
	year = date.getFullYear()

	date = month+"/"+day+"/"+year

	date = moment(date).format("M/D/YYYY");

	allowedFileTypes = ['png', 'jpg', 'jpeg']

	uploadImages = []

	deleteMessage = ->
		$("#message").remove()
	showMessage = (message, error, timeout=60000) ->

		if $("#messagetext").html() != message
			deleteMessage()


		if $("#message").length == 0 #Doesn't exist, make it
			$("body").append("<div id='message'><div id='messagetext'></div></div>")

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

	checkExt = (ext, cb) ->
		if(allowedFileTypes.indexOf(ext) > -1)
			return cb(null)

		return cb "Invalid File Type"
	calculateAspectRatioFit = (srcWidth, srcHeight, maxWidth, maxHeight) ->
		ratio = Math.min(maxWidth / srcWidth, maxHeight / srcHeight)
		width: srcWidth * ratio
		height: srcHeight * ratio

			
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

	obj = $("body")
	obj.on "dragenter", (e) ->
		e.stopPropagation()
		e.preventDefault()
		return

	obj.on "dragover", (e) ->
		e.stopPropagation()
		e.preventDefault()
		return

	obj.on "dragleave", (e) ->
		e.stopPropagation()
		e.preventDefault()
		$(".cover").fadeOut()
		return
	obj.on "drop", (e) ->
		e.preventDefault()
		$(".cover").show()
		files = e.originalEvent.dataTransfer.files
		console.log 5,files


		$.each files, (i, val) ->

			reader = new FileReader();
			
			reader.readAsDataURL(val);
			reader.onload = ->
				#$('.additemform').append('<input type="hidden" name="thumbnail" value="'+reader.result+'">');
					
				#$(".thumbnail").css "background-image", "url("+reader.result+")"
				image = new Image();
				image.src = reader.result
					
				image.onload = ->
					width = this.width
					height = this.height
					
					out = calculateAspectRatioFit(width, height, 1000, 1000)
					width = out["width"]
					height = out["height"]
						
					$(".thumbnail").css "width", width
					$(".thumbnail").css "height", height
					
					#Lets create a new canvas for each image
					num = uploadImages.length
					imageCode = "<div id='canvascontainer#{num}' class='image'> <canvas class='zoom canvas' id='canvas#{num}'></canvas> <input hidden id='date#{num}'> <div class='tools' id='tools#{num}' style='width:#{width}px;'> <div class='controlcontainer'> <img class='delete control' data-canvasnum=#{num} src='../img/delete.png'> <img class='rleft control' data-canvasnum='#{num}' src='../img/rotate.png'> <img class='date control' data-canvasnum='#{num}' src='../img/date.png'> <img class='rright control' data-canvasnum='#{num}' src='../img/rotate.png'> </div><div class='uploaddate' id='uploaddate#{num}'>#{date}</div></div></div>"
					$(".images").append(imageCode)

					canvas = $("#canvas"+num)[0];
					ctx = canvas.getContext("2d");
					
					image.width = width;
					image.height = height;
					canvas.width = width;
					canvas.height = height;
					
					ctx.drawImage(image, 0, 0, this.width, this.height);

					uploadImages.push([canvas.toDataURL("image/jpeg", 1), date])
					date = moment(date).add(1, 'd').format("M/D/YYYY");
					console.log uploadImages
			$(".cover").fadeOut()
			return 	


	$(".images").on 'click', '.delete', ->
		canvasnum = $(this).data('canvasnum')
		delete uploadImages[canvasnum]
		console.log uploadImages
		$("#canvascontainer#{canvasnum}").remove()

	$(".images").on 'click', '.date', ->
		canvasnum = $(this).data('canvasnum')
		$("#date#{canvasnum}").datepicker( onSelect: (dateText) ->
			uploadImages[canvasnum][1] = dateText
			$("#uploaddate#{canvasnum}").html(dateText)
			console.log "YEP"
		, minDate: 0
		, dateFormat: 'm/d/yy' 
		).show().focus().hide()
		console.log $("#date#{canvasnum}").val()


	$(".images").on 'click', '.rright', -> 
		canvasnum = $(this).data('canvasnum')
		canvas = $("#canvas#{canvasnum}")[0]
		#console.log canvasnum, canvas
		console.log "RIGHT"
		ctx = canvas.getContext("2d");

		image = new Image();
		image.src = canvas.toDataURL("image/jpeg", 1);
					
		image.onload = ->
			data = image
			canvas.width = data.height
			canvas.height = data.width
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			ctx.translate((data.height/2), data.width/2)
			ctx.rotate(90 * Math.PI/180);
			ctx.drawImage(data, -(data.width/2), -(data.height/2), data.width, data.height);

			uploadImages[canvasnum] = ([canvas.toDataURL("image/jpeg", 1), uploadImages[canvasnum][1]])


			$("#tools#{canvasnum}").width(canvas.width)
			return

	$(".images").on 'click', '.rleft', -> 
		canvasnum = $(this).data('canvasnum')
		canvas = $("#canvas#{canvasnum}")[0]
		console.log canvasnum, canvas
		ctx = canvas.getContext("2d");

		image = new Image();
		image.src = canvas.toDataURL("image/jpeg", 1);
					
		image.onload = ->
			data = image
			canvas.width = data.height
			canvas.height = data.width
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			ctx.translate((data.height/2), data.width/2)
			ctx.rotate(-90 * Math.PI/180);
			ctx.drawImage(data, -(data.width/2), -(data.height/2), data.width, data.height);

			uploadImages[canvasnum] = ([canvas.toDataURL("image/jpeg", 1), uploadImages[canvasnum][1]])
	
			$("#tools#{canvasnum}").width(canvas.width)
			return

	$("#upload").on "click",(e) ->
		e.preventDefault()
		if uploadImages.length == 0
			return showMessage "No Images Too Upload", true, 1000


		socket.emit "imageUpload", images: uploadImages, (result) ->
			showMessage "Uploading...", false, 15000
			$("html, body").animate	scrollTop: 0, "slow"
			if result.status
				return showMessage result.message, false, 5000
			else
				if result.overwriteDate?
					deleteMessage()
					if confirm("Overwite Image on Date: #{result.overwriteDate}")
						console.log "OVERWRITE"
						socket.emit "imageDelete", date: result.overwriteDate, (result) ->
							if result.status
								socket.emit "imageUpload", images: uploadImages, (result) ->
									if result.status
										console.log "Overwritten"
										return showMessage result.message, false, 5000
									else
										console.log "FAILED??? #{result.message}"
										#return showMessage "Failed: " + result.message, true, 5000
										#TODO... this error gets thrown even if nothing went wrong... possible fix is make an imageOverwite instead of using imageDelete and imageUpload...
							else
								return showMessage "Failed: " + result.message, true, 5000
				else	
					console.log 'problem'
					return showMessage "Failed: " + result.message, true, 5000
			return


	return