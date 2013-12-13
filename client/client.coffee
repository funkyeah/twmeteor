@responsive_state = ->
  $(".responsive-state").css "width"

Handlebars.registerHelper 'title', () ->
    Session.get("title")



## GK - Use version of this to highlight select beer badge
Handlebars.registerHelper 'pageIs', (u) ->
    page = Session.get('title')
    return u == "/" if page == undefined
    return u == page

Handlebars.registerHelper 'spaceIs', (space) ->
    currSpace = Session.get('space')
    return space == currSpace

# Session.set('editMode', false)

# Todo: reloadEntry = true
navigate = (location, context) ->
    Router.navigate(location, true)

evtNavigate = (evt) ->
    evt.preventDefault()
    window.scrollTo(0,0)
    $a = $(evt.target).closest('a')
    if $a.length is 0
        $a = $(evt.target).find('a')
    href = $a.attr('href')
    if href is '#'
        return
    localhost = document.location.host
    linkhost = $a[0].host
    if localhost == linkhost
        navigate(href)
    else
        window.open( href, '_blank')

Template.header.themeBright = ->
    return Session.get 'themeBright'

Template.header.events
    'click a.theme-select ': (evt) ->
        evt.preventDefault()
        $('body').toggleClass('theme-dark')
        $('body').toggleClass('theme-bright')
        Session.set('themeBright' , !Session.get('themeBright'))

    'click a': evtNavigate


Template.primaryNav.resizeHelper = ->
    responsive_state = Session.get "responsive_state"
    if responsive_state isnt '767px'
        $('.tw-navbar-collapse').collapse('show')
    return

Template.primaryNav.themeBright = ->
    return Session.get 'themeBright'


Template.primaryNav.events
    'click a': (evt) ->
        evtNavigate(evt)
        rstate = responsive_state()
        if rstate is '767px'
            $('.tw-navbar-collapse').collapse('hide')

Template.primaryNav.rendered = ->
    rstate = responsive_state()
    if rstate isnt '767px'
        $('.tw-navbar-collapse').collapse('show')
   
Template.banner.events
    'click a': evtNavigate

Template.banner_carousel.events
    'click a.btn': evtNavigate


Template.beers.events
    'click #beerTabs > li' : (evt) ->
        $el = $(evt.currentTarget)
        Session.set( 'activeTab' , $el.attr('id'))

Template.news.events
    'click a': evtNavigate

Template.news.posts = ->
    'click a': evtNavigate

Template.lower.events
    'click a': evtNavigate



Template.lower.created = ->
    if typeof twttr isnt "undefined"
        setTimeout (->
            twttr.widgets.load()
        ), 0

## Nav

Template.beers.isActiveTab = (tab, options)->
    Session.equals "activeTab", tab 


EntryRouter = Backbone.Router.extend({
    routes: {
        "search/:term": "search",
        "beers": "beers",
        "store" : "store",
        "contact" : "contact",
        "beers/:beer": "beer",
        ":title": "main",
        "": "home"
    },
    search: (term) ->
        Session.set( 'mode', 'search' )
        Session.set( 'space', 'search' )
        Session.set( 'search-term', decodeURIComponent( term ) )
    beers: () ->
        Session.set( 'mode', 'beer' )
        Session.set( 'space', 'beers' )
        Session.set( 'title', 'beers' )
    store: () ->
        Session.set( 'mode', 'store' )
        Session.set( 'space', 'main' )
        Session.set( 'title', 'store' )
    contact: () ->
        Session.set( 'mode', 'contact' )
        Session.set( 'space', 'main' )
        Session.set( 'title', 'contact' )
    beer: (beer) ->
        Session.set( 'mode', 'beer' )
        Session.set( 'space', 'beers' )
        Session.set( 'activeTab', decodeURIComponent( beer )+'Tab')
        Session.set( 'title', decodeURIComponent( beer ) )
    main: (title) ->
        Session.set('mode', 'entry')
        Session.set( 'space', 'main' )
        Session.set('title', decodeURIComponent( title ))
    home: (title) ->
        Session.set('mode', 'entry')
        Session.set( 'space', 'home' )
        Session.set('title', 'home')
})


Router = new EntryRouter

Meteor.startup ->
    Backbone.history.start pushState: true
    Session.set('activeTab', 'short-circuitTab')
    $(window).resize (evt) ->
        responsive_state = @.responsive_state()
        if responsive_state isnt '767px'
            $('.tw-navbar-collapse').collapse('show')
    $('body').addClass('theme-dark');
    Session.set('themeBright', false)
    Session.set('sendingEmail', false)
    Session.set('gmapsAPInotLoaded', true)
    # $("#gmaps-iframe").on "load", (e) ->
    #     Session.set('gmapsIframeNotLoaded', false)