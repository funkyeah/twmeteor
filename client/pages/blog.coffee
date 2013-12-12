Meteor.subscribe('blogPosts')

Template.blog.blog_posts = ->
  blog_posts = BlogPosts.find( {}, {sort: {date: -1}})
  return blog_posts