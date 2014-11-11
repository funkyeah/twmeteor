
#################################################################
#       Router Global
#################################################################
Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "not_found"
  loadingTemplate : "loading"


#################################################################
#       Filters
#################################################################
filters =
  resetScroll: ->
    scrollTo = window.currentScroll or 0
    if not Session.get('dontResetScroll')
      $("body").scrollTop scrollTo
    $("body").css "min-height", 0
    Session.set('dontResetScroll', false)
    this.next()

Router.onBeforeAction ->
  # check for ie8 or less (don't support document.addEventListener)
  if not document.addEventListener and not Session.get('oldBrowserProceed')
    console.log('ie8!')
    @render('upgrade_browser')
    @stop()
  if @url is '/'
    Session.set('currentPage', 'home')
  else
    Session.set('currentPage', @url.split("/")[1])
  this.next()

Router.onBeforeAction(filters.resetScroll)

# Router.onBeforeAction () ->
#   unless @ready()
#     @render "loading"
#     this.next()
#   return

# Router.onAfterAction ->
#   analyticsRequest() # log this request with mixpanel, etc

#################################################################
#       Routes
#################################################################
Router.map ->

  # Home
  @route 'home',
    path: '/'
    yieldTemplates:
      'subnav_announcement': to: 'subnav'
      'banner_carousel':     to: 'banner'
    onBeforeAction: ->
      Session.set('title', 'home')
      GAnalytics.pageview("/")
      this.next()

  # Admin
  @route "admin",
    path: "/admin"
    template: "accountsAdmin"
    onBeforeAction: ->
      AccountsEntry.signInRequired(this)
      this.next()

  # Beers
  @route 'beers',
    path: '/beers/:beer?'
    layoutTemplate: 
      'layout_with_subnav'
    yieldTemplates:
      'subnav_beers': to: 'subnav'
    onBeforeAction: ->
      GAnalytics.pageview("/beers")
      if this.params.beer?
        Session.set( 'activeBeerTab', this.params.beer)  
      this.next()

  # Blog
  @route 'blog',
    path: '/blog/'
    onBeforeAction: ->
      GAnalytics.pageview("/blog")
      isRedactorLoaded = Session.get('redactorLoaded')
      if Meteor.user() and not isRedactorLoaded
        jQuery.getScript '/redactor/redactor.js', ->
          Session.set('redactorLoaded', true)
      this.next()
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
      this.next()
    onAfterAction: ->
      r_state = responsive_state()
      if r_state isnt '767px'
        $("body").scrollTop 225
      this.next()

  # who
  @route 'who',
    yieldTemplates:
      'banner':
        to: 'banner'
    onBeforeAction: ->
      GAnalytics.pageview("/who")
      this.next()

  # where
  @route 'where',
    layoutTemplate: 
      'layout_with_subnav'
    yieldTemplates:
      'whereSubnav': to: 'subnav'
      'locationMap':  to: 'banner'
    onBeforeAction: ->
      Session.set('activeWhereTab', 'where')
      GAnalytics.pageview("/where")
      this.next()

  # where
  @route 'where_beers',
    template: 
      'whereBeers'
    layoutTemplate: 
      'layout_with_subnav'
    yieldTemplates:
      'whereSubnav': to: 'subnav'
      'beersMap': to: 'banner'
    onBeforeAction: ->
      Session.set('activeWhereTab', 'where_beers')
      GAnalytics.pageview("/where_beers")
      this.next()

  # where
  @route 'where_liquor_stores',
    template: 
      'whereBeers'
    layoutTemplate: 
      'layout_with_subnav'
    yieldTemplates:
      'whereSubnav': to: 'subnav'
      'liquorStoreMap': to: 'banner'
    onBeforeAction: ->
      Session.set('activeWhereTab', 'where_liquor_stores')
      GAnalytics.pageview("/where_liquor_stores")
      this.next()


  # store
  @route 'store',
    onBeforeAction: ->
      GAnalytics.pageview("/store")
      this.next()

  # jobs
  @route 'jobs',
    onBeforeAction: ->
      GAnalytics.pageview("/jobs")
      this.next()

  # taproom rental
  @route 'taproom_rental',
    template:
        'taproomRental'
    onBeforeAction: ->
      GAnalytics.pageview("/taproom_rental")
      this.next()

  # contact
  @route 'contact',
    onBeforeAction: ->
      GAnalytics.pageview("/contact")
      this.next()

  # protobrew
  @route 'protobrew',
    onBeforeAction: ->
      GAnalytics.pageview("/protobrew")
      this.next()
  

  
