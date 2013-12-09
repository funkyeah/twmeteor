Meteor.methods
    sendMessage: (fromName, fromEmail, msg, callback) ->
    	if emailIsValid(fromEmail) && fromName.length > 0 && msg.length > 0
	        Email.send
	            from: fromEmail
	            to: "robot@tinwhiskersbrewing.com"
	            replyTo: fromEmail or `undefined`
	            subject: "Website Email:" + " from " + fromName + " at " + fromEmail
	            text: msg
	    else
	    	throw new Meteor.Error(403, "Invalid Email Content")
                


#sendMessage = (fromName, fromEmail, msg) ->


#modify to include password
Meteor.startup ->
    # process.env.MAIL_URL = "smtp://robot%40tinwhiskersbrewing.com :$robot123@smtp.mailgun.org:587"
     process.env.MAIL_URL = "smtp://postmaster%40tinwhiskersbrewing.com:$robot123@smtp.mailgun.org:587"
    # process.env.MAIL_URL = "smtp://postmaster%40sandbox1733.mailgun.org:20r4l9tynvc6@smtp.mailgun.org:587"



# ContactUs.validateEmail = function(email) { 
#   // use either of these
#   //   /^([a-zA-Z0-9_.-\+])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/
#   //   /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\  ".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA  -Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
#   var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\  ".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA  -Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;    
#   if(!re.test(email)){
#     throw new Meteor.Error(500, 'Please enter a valid "email" address.'); 
#   }
# };