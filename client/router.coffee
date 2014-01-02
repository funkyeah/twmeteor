
#---------------------------------------------------------------
#                         Filters                              #
#---------------------------------------------------------------

# isLoggedIn
# isLoggedOut
# isAdmin
 
# canView
# canPost
# canEditPost
# canEditComment
 
# hasCompletedProfile

#---------------------------------------------------------------
#                           Controllers                        #
#---------------------------------------------------------------

# PostsListController
# PostPageController

#---------------------------------------------------------------
#                              Routes                          #
#---------------------------------------------------------------

# Home
# Beer listing
# Paginated Blog list
  # Blog Posts
    # Blog editing
# Who
# Where
# Contact
# Store


# Admin and Users

# User Profile
# User Edit
# Account
# Sign In
# Settings


#---------------------------------------------------------------
#                    Global Templates                          #
#---------------------------------------------------------------
Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "not_found"


#---------------------------------------------------------------
#                   Filters                                    #
#---------------------------------------------------------------
filters =

  resetScroll: ->
    scrollTo = window.currentScroll or 0
    $("body").scrollTop scrollTo
    $("body").css "min-height", 0


Router.before ->
  if @path is '/'
    Session.set('page', 'home')
  else 
    Session.set('page', @path.split("/")[1])

Router.before(filters.resetScroll)

# Router.after ->
#   analyticsRequest() # log this request with mixpanel, etc


@evtNavigate = (evt) ->
    evt.preventDefault()
    $a = $(evt.target).closest('a')
    if $a.length is 0
        $a = $(evt.target).find('a')
    href = $a.attr('href')
    if href is '#'
        return
    localhost = document.location.host
    linkhost = $a[0].host
    if localhost == linkhost
        Router.go(href)
    else
        window.open( href, '_blank')

# Unload Hooks

#

#--------------------------------------------------------------------------------------------------//
#------------------------------------------- Controllers ------------------------------------------//
#--------------------------------------------------------------------------------------------------//

# Controller for all posts lists
PostsListController = RouteController.extend(
  template: "posts_list"
  waitOn: ->
    
    # take the first segment of the path to get the view, unless it's '/' in which case the view default to 'top'
    # note: most of the time this.params.slug will be empty
    @_terms =
      view: (if @path is "/" then "top" else @path.split("/")[1])
      limit: @params.limit or getSetting("postsPerPage", 10)
      category: @params.slug
      query: Session.get("searchQuery")

    [Meteor.subscribe("postsList", @_terms), Meteor.subscribe("postsListUsers", @_terms)]

  data: ->
    parameters = getParameters(@_terms)
    posts = Posts.find(parameters.find, parameters.options)
    postsCount = posts.count()
    Session.set "postsLimit", @_terms.limit
    postsList: posts
    postsCount: postsCount

  after: ->
    view = (if @path is "/" then "top" else @path.split("/")[1])
    Session.set "view", view
)

# Controller for post digest
# BlogListController = RouteController.extend(
#   template: "posts_digest"
#   waitOn: ->
    
#     # if day is set, use that. If not default to today
#     currentDate = (if @params.day then new Date(@params.year, @params.month - 1, @params.day) else Session.get("today"))
#     terms =
#       view: "digest"
#       after: moment(currentDate).startOf("day").valueOf()
#       before: moment(currentDate).endOf("day").valueOf()

#     [Meteor.subscribe("postsList", terms), Meteor.subscribe("postsListUsers", terms)]

#   data: ->
#     currentDate = (if @params.day then new Date(@params.year, @params.month - 1, @params.day) else Session.get("today"))
#     terms =
#       view: "digest"
#       after: moment(currentDate).startOf("day").valueOf()
#       before: moment(currentDate).endOf("day").valueOf()

#     parameters = getParameters(terms)
#     Session.set "currentDate", currentDate
#     posts: Posts.find(parameters.find, parameters.options)
# )

# Controller for post pages
PostPageController = RouteController.extend(
  template: "post_page"
  waitOn: ->
    [Meteor.subscribe("singlePost", @params._id), Meteor.subscribe("postComments", @params._id), Meteor.subscribe("postUsers", @params._id)]

  data: ->
    postId: @params._id

  after: ->
    window.queueComments = false
    window.openedComments = []
)

# TODO: scroll to comment position

# Controller for comment pages
CommentPageController = RouteController.extend(
  waitOn: ->
    [Meteor.subscribe("singleComment", @params._id), Meteor.subscribe("commentUser", @params._id), Meteor.subscribe("commentPost", @params._id)]

  data: ->
    comment: Comments.findOne(@params._id)

  after: ->
    window.queueComments = false
)

# Controller for user pages
UserPageController = RouteController.extend(
  waitOn: ->
    Meteor.subscribe "singleUser", @params._idOrSlug

  data: ->
    findById = Meteor.users.findOne(@params._idOrSlug)
    findBySlug = Meteor.users.findOne(slug: @params._idOrSlug)
    if typeof findById isnt "undefined"
      
      # redirect to slug-based URL
      Router.go getProfileUrl(findById),
        replaceState: true

    else
      user: (if (typeof findById is "undefined") then findBySlug else findById)
)

#--------------------------------------------------------------------------------------------------//
#--------------------------------------------- Routes ---------------------------------------------//
#--------------------------------------------------------------------------------------------------//

Router.map ->

  # Home
  @route 'home',
    path: '/'
    yieldTemplates:
      'banner_carousel':
        to: 'banner'
    before: ->
      Session.set('title', 'home')

  # Admin
  @route 'admin'

  # Beers
  @route 'beers',
    path: '/beers/:beer?'
    before: ->
      if this.params.beer?
        Session.set( 'activeBeerTab', this.params.beer)
    # controller: BeersListController
    

  # Blog
  @route 'blog',
    path: '/blog/:blogPostID?'
    # controller: BlogListController

  # who
  @route 'who',
    yieldTemplates:
      'banner':
        to: 'banner'

  # where
  @route 'where',
    yieldTemplates:
      'locationMap':
        to: 'banner'

  # store
  @route 'store'

  # contact
  @route 'contact'
  
  # -------------------------------------------- Users -------------------------------------------- //
  
  # User Profile
  @route "user_profile",
    path: "/users/:_idOrSlug"
    controller: UserPageController

  
  # User Edit
  @route "user_edit",
    path: "/users/:_idOrSlug/edit"
    controller: UserPageController

  
  # Account
  @route "account",
    path: "/account"
    template: "user_edit"
    data: ->
      user: Meteor.user()

  

  
  # User Sign-Up
  @route "signup"
  
  # User Sign-In
  @route "signin"
  
  # -------------------------------------------- Other -------------------------------------------- //
  

  # Settings
  @route "settings"
  

  
