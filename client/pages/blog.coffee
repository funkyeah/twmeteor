Meteor.subscribe('blogPosts')

Template.blog.blog_posts = ->
  blog_posts = BlogPosts.find( {}, {sort: {date: -1}})
  return blog_posts

Template.blog.notEditing = ->
     return not Session.get('editPostId')

Template.blog.addingPost = ->
     return Session.get('addingPost')

 Template.blog.events
    'click .addPostButton' : (evt) ->
        evt.preventDefault()
        Session.set('addingPost', true);


Template.blogPost.notEditing = ->
     return not Session.get('editPostId')

Template.blogPost.editing = ->
     return Session.equals('editPostId', this._id);


Template.blogEdit.events
    'click .cancelEdit' : (evt) ->
        evt.preventDefault()
        Session.set('addingPost', false);
        Session.set('editPostId', false);

    'click .saveEdit' : (evt) ->
        evt.preventDefault()
        savePost( evt )
        Session.set('addingPost', false);
        Session.set('editPostId', false);

Template.blogPost.events
    'click .editPostButton' : (evt) ->
        evt.preventDefault()
        Session.set('editPostId', this._id);
    
    'click .deletePostButton': (evt) ->
        evt.preventDefault()
        Session.set('deletePostId', this._id);
        $('#delete-confirm-input').val('')
        $('#delete-confirm-modal').modal('show')


Template.deleteConfirmModal.events
    'click #delete-confirm-button': (e) ->
        deleteInput = $('#delete-confirm-input').val()
        if deleteInput == "DELETE"
            deletePost()
            $('#delete-confirm-modal').modal('hide')

    'click #delete-cancel-button': (e) ->
        $('#delete-confirm-modal').modal('hide')



Template.blogEdit.rendered = ->
    el = $( '#post-edit-content' )
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


@savePost = (evt) ->
    postId = Session.get('editPostId');
    post = {
        'title': $('#post-edit-title-input').val()
        'day' : $('#post-edit-day-input').val()
        'date' : $('#post-edit-date-input').val()
        'time' : $('#post-edit-time-input').val()
        'content': rewriteLinks( $('#post-edit-content').val() )
        'mode': $('#mode').val()
    }
    Meteor.call('savePost', postId, post)
    if BlogPosts.findOne({_id: postId})
        BlogPosts.update({_id: postId}, post)
    else
        BlogPosts.insert(post)     

@deletePost = (evt) ->
    postId = Session.get('deletePostId')
    if postId
        Meteor.call('deletePost',postId)
        BlogPosts.remove({_id: postId})


@rewriteLinks = ( text ) ->
    $html = $('<div>')
    $html.html( text )

    for el in $html.find( 'a' )
        href = $(el).attr( 'href' )
        if href
            href = href.replace( /https?:\/\/([^\/.]+)$/, '/$1' )
            $(el).attr( 'href', href )
            $(el).addClass( 'entry-link' )

    $html.html()
