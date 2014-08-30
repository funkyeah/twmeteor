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


Template.news.events
    'click a': evtNavigate

Template.footer.events
    'click a': evtNavigate

Template.home.events
    'click a': @evtNavigate
    'click #taproom-map' : ->
        Router.go('where')


Template.home.created = ->
    if typeof twttr isnt "undefined"
        setTimeout (->
            twttr.widgets.load()
        ), 0

        
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
    Session.set('storemapperLoaded', false)
    Session.set('editPostId', false)
    Session.set('addingPost', false)
    Session.set('redactorLoaded', false)
    Session.set('subscriptionSubmitted', false)


    AccountsEntry.config
        homeRoute: "/" # mandatory - path to redirect to after sign-out
        dashboardRoute: "/" # mandatory - path to redirect to after successful sign-in
        passwordSignupFields: "EMAIL_ONLY"
        showOtherLoginServices: true # Set to false to hide oauth login buttons on the signin/signup pages. Useful if you are using something like accounts-meld or want to oauth for api access
  return