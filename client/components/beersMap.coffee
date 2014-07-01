Template.beersMap.rendered = ->
    if not Session.get('storemapperLoaded')
        Meteor.Loader.loadJs "http://www.storemapper.co/js/widget.js"
        Session.set('storemapperLoaded', true)


