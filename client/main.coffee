@responsive_state = ->
  $(".responsive-state").css "width"

Handlebars.registerHelper 'page', () ->
    Session.get('page')

Handlebars.registerHelper('postLink', (blogPost) ->
  postLink(blogPost)
)

## GK - Use version of this to highlight select beer badge
Handlebars.registerHelper 'pageIs', (u) ->
    page = Session.get('page')
    return u == "/" if page == undefined
    return u == page

Template.upgrade_browser.events
    'click button.old-browser-proceed': (evt) ->
        evt.preventDefault()
        Session.set('oldBrowserProceed', true)

Template.header.themeBright = ->
    return Session.get 'themeBright'

Template.header.events
    'click a.theme-select ': (evt) ->
        evt.preventDefault()
        $('body').toggleClass('theme-dark')
        $('body').toggleClass('theme-bright')
        Session.set('themeBright' , !Session.get('themeBright'))

    'click a': evtNavigate

Template.primaryNav.primaryNavCollapse = ->
    Session.get('primaryNavCollapse')

Template.primaryNav.themeBright = ->
    return Session.get 'themeBright'


Template.primaryNav.events
    'click a': (evt) ->
        evtNavigate(evt)
        r_state = responsive_state()
        if r_state is '767px'
            Session.set('primaryNavCollapse', '')  

Template.primaryNav.rendered = ->
    r_state = responsive_state()
    if r_state isnt '767px'
        Session.set('primaryNavCollapse', 'in')  
    else
        Session.set('primaryNavCollapse', '')  
   
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
        responsive_state = @responsive_state()
        if responsive_state isnt '767px'
            Session.set('primaryNavCollapse', 'in')  
    $('body').addClass('theme-dark');
    Session.set('themeBright', false)
    Session.set('sendingEmail', false)
    Session.set('gmapsAPInotLoaded', true)
    Session.set('editPostId', false)
    Session.set('addingPost', false)
    Session.set('redactorLoaded', false)
    Session.set('subscriptionSubmitted', false)
