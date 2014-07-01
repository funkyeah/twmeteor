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
Template.subnav_where.events
    'click .subnav button' : (evt) ->
        $el = $(evt.currentTarget)
        Router.go($el.data('wheretab'))

Template.where_beers.isActiveWhereTab = (tab)->
    Session.equals "activeWhereTab", tab

Template.subnav_where.isActiveWhereTab = (tab)->
    Session.equals "activeWhereTab", tab 