
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


Router.onBeforeAction ->
  # check for ie8 or less (don't support document.addEventListener)
  if not document.addEventListener and not Session.get('oldBrowserProceed')
    console.log('ie8!')
    @render('upgrade_browser')
    @stop()
  if @path is '/'
    Session.set('page', 'home')
  else 
    Session.set('page', @path.split("/")[1])

Router.onBeforeAction(filters.resetScroll)

# Router.onAfterAction ->
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
    Router.go(href)

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
    onBeforeAction: ->
      Session.set('title', 'home')
      GAnalytics.pageview("/")

  # Admin
  @route 'admin'

  # Beers
  @route 'beers',
    path: '/beers/:beer?'
    onBeforeAction: ->
      GAnalytics.pageview("/beers")
      if this.params.beer?
        Session.set( 'activeBeerTab', this.params.beer)  

  # Blog
  @route 'blog',
    path: '/blog/'
    onBeforeAction: ->
      GAnalytics.pageview("/blog")
      isRedactorLoaded = Session.get('redactorLoaded')
      if Meteor.user() and not isRedactorLoaded
        jQuery.getScript '/redactor/redactor.js', ->
          Session.set('redactorLoaded', true)
    waitOn: ->
      Meteor.subscribe 'blogPosts'
    data: ->
      blogPosts: BlogPosts.find({}, {sort: {date: -1, time: -1}})

  @route 'blogPost',
    path: '/blog/:blogPostSlug'
    waitOn: ->
      Meteor.subscribe('singlePost', @params.blogPostSlug)
    data: ->
      BlogPosts.findOne({slug: @params.blogPostSlug})
    onBeforeAction: ->
      GAnalytics.pageview("/blog/"+@params.blogPostSlug)
      isRedactorLoaded = Session.get('redactorLoaded')
      if Meteor.user() and not isRedactorLoaded
        jQuery.getScript '/redactor/redactor.js', ->
          Session.set('redactorLoaded', true)
    onAfterAction: ->
      r_state = responsive_state()
      if r_state isnt '767px'
        $("body").scrollTop 225

  # who
  @route 'who',
    yieldTemplates:
      'banner':
        to: 'banner'
    onBeforeAction: ->
      GAnalytics.pageview("/who")

  # where
  @route 'where',
    yieldTemplates:
      'locationMap':
        to: 'banner'
    onBeforeAction: ->
      GAnalytics.pageview("/where")

  # where
  @route 'where_beers',
    layoutTemplate: 
      'layout_where'
    yieldTemplates:
      'where_tabs': to: 'where_tabs'
      'beersMap': to: 'banner',
    onBeforeAction: ->
      GAnalytics.pageview("/where_beers")

  # store
  @route 'store',
    onBeforeAction: ->
      GAnalytics.pageview("/store")

  # jobs
  @route 'jobs',
    onBeforeAction: ->
      GAnalytics.pageview("/jobs")

  # taproom rental
  @route 'taproom_rental',
    onBeforeAction: ->
      GAnalytics.pageview("/taproom_rental")

  # contact
  @route 'contact',
    onBeforeAction: ->
      GAnalytics.pageview("/contact")

  # protobrew
  @route 'protobrew',
    onBeforeAction: ->
      GAnalytics.pageview("/protobrew");

  
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
    

  # Settings
  @route "settings"
  

  
