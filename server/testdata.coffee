## intial users setup


Meteor.startup ->
    if @BlogPosts.find().count() is 0
        blogPosts = [

          title: "Title of blog post 1"
          day: "Wednesday"
          datetime: "2013-12-31T01:00"
          content: "content of test post 1"
        ,
          title: "Title of the second test blog post "
          day: "Monday"
          datetime: "2013-12-31T01:00"
          content: "content of test post 2 with some html here: <div><h1>text</h1></div>"

        ]
        _.each blogPosts, (blogPost) ->
            console.log blogPost
            @BlogPosts.insert({ title: blogPost.title, day: blogPost.day, datetime: blogPost.datetime, content: blogPost.content } )

if Meteor.users.find().count() is 0
    users = [

      name: "Editor User"
      email: "jenna.seal@gmail.com"
      roles: ["editor"]
    ,
      name: "Admin User"
      email: "george@tinwhiskersbrewing.com"
      roles: ["admin"]
    ]
    _.each users, (user) ->
        id = undefined
        id = Accounts.createUser(
            email: user.email
            password: "default"
            profile:
                name: user.name
        )
        console.log user
        Roles.addUsersToRoles id, user.roles  if user.roles.length > 0
