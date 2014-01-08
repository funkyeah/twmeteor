
#################################################################
#       Filters
#################################################################

# isLoggedIn
# isLoggedOut
# isAdmin
 
# canView
# canPost
# canEditPost
# canEditComment

#################################################################
#       Routes
#################################################################

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


#################################################################
#       Router Global
#################################################################
Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "not_found"


#################################################################
#       Filters
#################################################################
filters =

  resetScroll: ->
    scrollTo = window.currentScroll or 0
    $("body").scrollTop scrollTo
    $("body").css "min-height", 0


Router.before ->
  # check for ie8 or less (don't support document.addEventListener)
  if not document.addEventListener and not Session.get('oldBrowserProceed')
    console.log('ie8!')
    @render('upgrade_browser')
    @stop()
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


#################################################################
#       Routes
#################################################################

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
    

  # Blog
  @route 'blog',
    path: '/blog/'
    waitOn: ->
      Meteor.subscribe 'blogPosts'
    data: ->
      blogPosts: BlogPosts.find({}, {date: -1, time: -1})

  @route 'blogPost',
    path: '/blog/:blogPostSlug'
    waitOn: ->
      Meteor.subscribe 'singlePost', @params.blogPostSlug
    data: ->
      BlogPosts.findOne({slug: @params.blogPostSlug})

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
    # controller: UserPageController

  
  # User Edit
  @route "user_edit",
    path: "/users/:_idOrSlug/edit"
    # controller: UserPageController

  
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
  

  
