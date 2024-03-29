#modify to include password
Meteor.startup ->
    # process.env.MAIL_URL = "smtp://robot%40tinwhiskersbrewing.com :$robot123@smtp.mailgun.org:587"
    # process.env.MAIL_URL = "smtp://postmaster%40tinwhiskersbrewing.com:$robot123@smtp.mailgun.org:587"
    process.env.MAIL_URL = "smtp://postmaster%40sandbox1733.mailgun.org:20r4l9tynvc6@smtp.mailgun.org:587"

Meteor.methods
    sendMessage: (fromName, fromEmail, msg, callback) ->
        if emailIsValid(fromEmail) && fromName.length > 0 && msg.length > 0
            Email.send
                from: fromEmail
                to: "robot@twbrewing.com"
                replyTo: fromEmail or `undefined`
                subject: "Website Email:" + " from " + fromName + " at " + fromEmail
                text: msg
        else
            throw new Meteor.Error(403, "Invalid Email Content")

    savePost: (postId, post) ->
        loggedInUser = Meteor.user()
        post = verifySave(postId, post, loggedInUser)
        if BlogPosts.findOne({_id: postId})
            BlogPosts.update({_id: postId}, post)
        else
            BlogPosts.insert(post) 

    deletePost:(postId) ->
        # add permission check
        console.log(postId)
        if postId?
            BlogPosts.remove({_id: postId})
        else
            return


Meteor.publish 'blogPosts', () ->
    # Todo: Temporary
    BlogPosts.find({}, {sort: {date: -1, time: -1}})

Meteor.publish 'singlePost', (slug) ->
  BlogPosts.find slug: slug



# Meteor.publish("userData", ->
#     Meteor.users.find({_id: this.userId}, {fields: {'username': 1, 'group': 1, 'profile': 1}})
# )

# Meteor.publish("allUserData", () ->
#   user = Meteor.users.findOne({_id: this.userId}) if this.userId
#   if user && user.group == "admin"
#     return Meteor.users.find();
#   else
#     Meteor.users.find({}, {fields: {'username': 1}});
# )