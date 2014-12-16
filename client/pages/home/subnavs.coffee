#################################
## beer subnav
#################################
Template.subnav_beers.events
    'click .subnav button' : (evt) ->
        $el = $(evt.currentTarget)
        Session.set( 'activeBeerTab' , $el.data('beertab'))

Template.beers.isActiveTab = (tab)->
    Session.equals "activeBeerTab", tab

Template.subnav_beers.isActiveTab = (tab)->
    Session.equals "activeBeerTab", tab 


#################################
## where subnav
#################################
Template.whereSubnav.events
    'click .subnav button' : (evt) ->
        $el = $(evt.currentTarget)
        Router.go($el.data('wheretab'))

Template.whereSubnav.isActiveWhereTab = (tab)->
    Session.equals "activeWhereTab", tab 

#################################
## announcement/home subnav
#################################
Template.subnav_announcement.events
    'click announcement-store-btn' : (evt) ->
        Router.go('store')
