Template.contact.events
    'click button[type=submit]': (evt) ->
        evt.preventDefault()
        fromName  = $('#contact-name-input').val() 
        fromEmail = $('#contact-email-input').val() 
        msg       = $('#contact-msg-input').val() 
        if emailIsValid(fromEmail) && fromName.length > 0 && msg.length > 0
            Meteor.call 'sendMessage', fromName, fromEmail, msg, (error, response) ->
                if error
                    Toast.error('Undescriptive Error Message')
                else
                    Toast.success('Congratulations, your electronic mail has been sent on a journey through interwebs. Wish it luck!') 
        else
            if not emailIsValid(fromEmail)
                Toast.error('My regular expression is telling me your email is not valid and it rarely lies.')
            if fromName.length is 0 
                Toast.error('You should at least give us a fake name.')
            if msg.length is 0
                Toast.error('An email without a message is not much of an email.')

    'keypress #contact-email-input': (evt) ->   
        fromEmail = $('#contact-email-input').val()  
        if emailIsValid(fromEmail)
            console.log 'good email'
            $('#contact-email-input').parent().addClass('has-success')
            $('#contact-email-input').parent().removeClass('has-error')
        else  
            console.log 'bad email'
            $('#contact-email-input').parent().addClass('has-error')
            $('#contact-email-input').parent().removeClass('has-success')
