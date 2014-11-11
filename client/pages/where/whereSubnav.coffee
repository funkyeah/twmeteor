Template.whereSubnav.events
    'click .subnav where-btn' : ->
        Session.set('dontResetScroll', true)
        Router.go('where')
    'click .subnav where-beers-btn' : ->
        Session.set('dontResetScroll', true)
        Router.go('where_beers')
    'click .subnav where-liquor-stores-btn' : ->
        Session.set('dontResetScroll', true)
        Router.go('where_liqour_stores')