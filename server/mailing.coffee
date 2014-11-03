# Meteor.startup ->
#     MailChimpOptions.apiKey = "9776d245abf3c7fd5a4d9c583d3f02ad-us8"
#     MailChimpOptions.listId = "56815b508d"

Meteor.methods
    subscribe: (email) ->
        if not emailIsValid(email)
            return
        apiKey = "9776d245abf3c7fd5a4d9c583d3f02ad-us8"
        options =
           id : "56815b508d"
           email: 
                email: email

        MailChimpAPI = new MailChimp(
            apiKey
            version: '2.0'
        )

        MailChimpAPI.call "lists", "subscribe", options, (error,data)->
            return
