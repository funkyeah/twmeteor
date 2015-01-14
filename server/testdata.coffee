## intial users setup


Meteor.startup ->
    if BlogPosts.find().count() is 0
        blogPosts = [
          content: "<p>blog post 1 content html</p>"
          title: "Title of blog post 1"
          day: "Wednesday"
          date: "2013-12-31"
          summary: "summary of blog post 1"
          time: "01:00"
          content: "content of test post 1"
          slug: "title-of-blog-post-1"
          titleImageLink: ""
        ,
          content: "<p>2nd post content html</p>"
          title: "Title of the second test blog post "
          day: "Monday"
          datetime: "2013-12-31"
          summary: "summary text for the second blog post"
          time: "01:00"
          content: "content of test post 2 with some html here: <div><h1>text</h1></div>"
          slug: "title-of-the--second-test-blog-post"
          titleImageLink: ""
        ]
        _.each blogPosts, (blogPost) ->
            console.log blogPost
            @BlogPosts.insert({ title: blogPost.title, day: blogPost.day, date: blogPost.date, time: blogPost.time, content: blogPost.content } )

if Meteor.users.find().count() is 0
    users = [

      name: "Editor User"
      email: "jennaseal@gmail.com"
      roles: ["editor"]
    ,
      name: "Editor User"
      email: "ryan15pet@gmail.com"
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

#################################################################
#       Migrate
#################################################################
Meteor.startup ->
  BlogPosts.find().forEach (post)->
    if typeof post.slug is "undefined"
      convertToSlug = (Text) ->
        Text.toLowerCase().replace(RegExp(" ", "g"), "-").replace(/[^\w-]+/g, "")
      slug = convertToSlug(post.title)
      BlogPosts.update post._id,
        $set:
          slug: slug


  if Roles.getUsersInRole(['admin']).count() == 0
    userObserverCursor = Meteor.users.find({})
    userObserverCursor.observe
      added: (doc) ->
        if ( userObserverCursor.count() == 1)
          user = Meteor.users.findOne({})
          Roles.addUsersToRoles(user._id, ["admin"])
          console.log('added admin and editor for '+ user._id)