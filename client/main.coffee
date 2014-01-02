@responsive_state = ->
  $(".responsive-state").css "width"

Handlebars.registerHelper 'page', () ->
    Session.get('page')

## GK - Use version of this to highlight select beer badge
Handlebars.registerHelper 'pageIs', (u) ->
    page = Session.get('page')
    return u == "/" if page == undefined
    return u == page

Handlebars.registerHelper 'spaceIs', (space) ->
    currSpace = Session.get('space')
    return space == currSpace


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
        Session.set( 'activeBeerTab' , $el.data('beertab'))

Template.news.events
    'click a': evtNavigate

Template.footer.events
    'click a': evtNavigate

Template.home.events
    'click a': @evtNavigate


Template.home.created = ->
    if typeof twttr isnt "undefined"
        setTimeout (->
            twttr.widgets.load()
        ), 0

## Nav

Template.beers.isActiveTab = (tab, options)->
    Session.equals "activeBeerTab", tab 


Meteor.startup ->
    Session.set('activeBeerTab', 'short-circuit')
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