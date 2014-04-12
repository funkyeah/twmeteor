Template.subscribeInput.events
  "focus #subscribe-email-input, paste #subscribe-email-input, cut #subscribe-email-input": (e) ->
      email = $('#subscribe-email-input').val()
      if emailIsValid(email)
          $('#subscribe-email-input').parent().addClass('has-success')
          $('#subscribe-email-input').parent().removeClass('has-error')
      else  
          $('#subscribe-email-input').parent().addClass('has-error')
          $('#subscribe-email-input').parent().removeClass('has-success')


  "keypress #subscribe-email-input": (e) ->
    key = e.which or e.keyCode or e.charCode
    email = $('#subscribe-email-input').val()
    if emailIsValid(email)
        $('#subscribe-email-input').parent().addClass('has-success')
        $('#subscribe-email-input').parent().removeClass('has-error')
        if key is 13
          subscribe(email)
    else  
        $('#subscribe-email-input').parent().addClass('has-error')
        $('#subscribe-email-input').parent().removeClass('has-success')
      

  "click #subscribe-email-button": (e) ->
    email = $('#subscribe-email-input').val()
    subscribe(email)
        
subscribe = (email)->
  if emailIsValid(email)
    Session.set('subscriptionSubmitted', true)
    #disable submit button
    Toast.success('Email added, you should see a confirmation in your inbox.')
    Meteor.call('subscribe', email)
  else
    Toast.error('Email invalid, try again.')


Template.subscribeInput.subscriptionSubmitted = ->
  return Session.get('subscriptionSubmitted')
