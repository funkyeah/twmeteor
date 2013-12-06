@emailIsValid = (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\  ".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA  -Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    if re.test(email)
        return true
    else
        return false
    # throw new Meteor.Error(500, "Please enter a valid \"email\" address.")  unless re.test(email)