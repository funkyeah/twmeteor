Handlebars.registerHelper 'title', () ->
    Session.get("title")



## GK - Use version of this to highlight select beer badge
Handlebars.registerHelper 'pageIs', (u) ->
    page = Session.get('title')
    return u == "/" if page == undefined
    return u == page

Handlebars.registerHelper 'spaceIs', (space) ->
    space = Session.get('space')


# Meteor.subscribe 'entries', onComplete = ->
#   Session.set('entryLoaded', true)


# Meteor.subscribe('allUserData')

# Meteor.autosubscribe( ->
#     Meteor.subscribe("userData");
# );

# Session.set('editMode', false)

# Todo: reloadEntry = true
# navigate = (location, context) ->
#     location = "/u/#{context}/#{location}" if context
#     Router.navigate(location, true)

# evtNavigate = (evt) ->
#     evt.preventDefault()
#     window.scrollTo(0,0)
#     $a = $(evt.target).closest('a')
#     href = $a.attr('href')
#     localhost = document.location.host
#     linkhost = $a[0].host
#     if localhost == linkhost
#         navigate(href)
#     else
#         window.open( href, '_blank')
   

## Nav

# Template.leftNav.isActiveTab = (tab, options)->
#     Session.equals "activeTab", tab 

# Template.leftNav.isActivePanel = (panel, options)->
#     Session.equals "activePanel", panel

# Template.leftNav.term = -> 
#     Session.get( 'search-term' )

# ## GK - Use version of this to highlight select beer badge
# Template.leftNav.pageIs = (u) ->
#     page = Session.get('title')
#     return u == "/" if page == undefined
#     return u == page





## Entry

# Template.entry.title = ->
#     Session.get("title")

# Template.entry.entryLoaded = ->
#     Session.get("entryLoaded")

# Template.entry.editable = ->
#     entry = Session.get('entry')
#     context = Session.get("context")
#     user  = Meteor.user()
#     editable( entry, user, context )


# Template.entry.adminable = ->
#     user  = Meteor.user()
#     adminable( user, context )

# Template.entry.modeIs = (v) ->
#     return v == Session.get('entry').mode

# Template.entry.entryLoaded = ->
#     Session.get('entryLoaded')


# Template.main.modeIs = (mode) ->
#     Session.get('mode') == mode;

# Template.main.loginConfigured = () ->
#     if Accounts.loginServicesConfigured()
#         return true;
#     else
#         return false;


EntryRouter = Backbone.Router.extend({
    routes: {
        "search/:term": "search",
        "beers": "beers",
        "beers/:beer": "beer",
        ":title": "main",
        "": "home"
    },
    search: (term) ->
        Session.set( 'mode', 'search' )
        Session.set( 'search-term', decodeURIComponent( term ) )
    beers: (beers) ->
        Session.set( 'mode', 'beer' )
        Session.set( 'space', 'beers' )
        Session.set( 'title', 'beers' )
    beer: (beer) ->
        Session.set( 'mode', 'beer' )
        Session.set( 'space', 'beers' )
        Session.set( 'title', decodeURIComponent( beer ) )
    main: (title) ->
        Session.set('mode', 'entry')
        Session.set('title', decodeURIComponent( title ))
    home: (title) ->
        Session.set('mode', 'entry')
        Session.set('title', 'home')
})


Router = new EntryRouter

Meteor.startup ->
    Backbone.history.start pushState: true