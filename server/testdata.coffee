## intial users setup

# users = [

#   name: "Editor User"
#   email: "jenna.seal@gmail.com"
#   roles: ["editor"],

#   name: "Admin User"
#   email: "george@tinwhiskersbrewing.com"
#   roles: ["admin"]
# ]
# _.each users, (user) ->
#   id = undefined
#   id = Accounts.createUser(
#     email: user.email
#     password: "default"
#     profile:
#       name: user.name
#   )
#   Roles.addUsersToRoles id, user.roles  if user.roles.length > 0

Meteor.startup ->
    # @BlogPosts.insert({ title: 'title', date: 'date', content: 'content' } )
    if @BlogPosts.find().count() is 0
        blogPosts = [

          title: "Title of blog post 1"
          date: "Mon Jun 17 2013 02:18:07 GMT-0500"
          content: "content of test post 1"
        ,

          title: "Title of the second test blog post "
          date: "Wed Dec 09 1999 01:19:01 GMT-0500"
          content: "content of test post 2 with some html here: <div><h1>text</h1></div>"

        ]
        _.each blogPosts, (blogPost) ->
            console.log blogPost
            @BlogPosts.insert({ title: blogPost.title, date: blogPost.date, content: blogPost.content } )
