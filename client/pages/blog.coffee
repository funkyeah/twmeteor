Meteor.subscribe('blogPosts')

Template.blog.blog_posts = ->
  blog_posts = BlogPosts.find( {}, {sort: {date: -1}})
  return blog_posts


Template.blogPost.editing = ->
     return Session.equals('editPostId', this._id);

Template.blogPost.events
	'click .editBlogButton' : (evt) ->
		evt.preventDefault()
		Session.set('editPostId', this._id);


Template.blogEdit.rendered = ->
    el = $( '#post-content' )
    el.redactor(
        imageUpload: '/images'
        # linebreaks: true # buggy - insert link on last line, hit enter to break,
        # with cursor on newline try to insert link (modal only show edit of previous link)
        buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', 'deleted', '|',
                  'unorderedlist', 'orderedlist', 'outdent', 'indent', '|',
                  'image', 'table', 'link', '|',
                  'fontcolor', 'backcolor', '|', 'alignment', '|', 'horizontalrule'],
        focus: true
        autoresize: true
        # filepicker: (callback) ->
        #     filepicker.setKey('AjmU2eDdtRDyMpagSeV7rz')
        #     filepicker.pick({mimetype:"image/*"}, (file) ->
        #         filepicker.store(file, {location:"S3", path: Meteor.userId() + "/" + file.filename },
        #         (file) -> callback( filelink: file.url )))
    )