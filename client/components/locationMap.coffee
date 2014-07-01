Template.locationMap.gmapsIframeNotLoaded = ->
    return Session.get 'gmapsAPInotLoaded'


@makeGmap = ->
    Session.set('gmapsAPInotLoaded', false)
    # Black and white
    styles = [{"featureType":"landscape.natural","stylers":[{"saturation":-100},{"lightness":100}]},{"featureType":"water","stylers":[{"saturation":-100},{"lightness":-86}]},{"elementType":"labels.text.stroke","stylers":[{"saturation":-100},{"lightness":100}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"saturation":-100},{"lightness":-75}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"saturation":-100},{"lightness":97}]},{"featureType":"poi.park","stylers":[{"saturation":-100},{"lightness":-100}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"saturation":-100},{"lightness":100}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"on"}]},{"featureType":"landscape.man_made","stylers":[{"saturation":-100},{"lightness":-68}]},{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"saturation":-100},{"lightness":100}]},{"featureType":"administrative","elementType":"labels.text.stroke","stylers":[{"saturation":-100},{"lightness":-100}]},{"featureType":"poi","stylers":[{"saturation":-100},{"lightness":91}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"saturation":-100},{"lightness":-100}]},{"featureType":"transit.station","stylers":[{"saturation":-100},{"lightness":-22}]},{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"hue":"#ff004c"},{"saturation":-100},{"lightness":44}]},{"elementType":"labels.text.fill","stylers":[{"saturation":1},{"lightness":-100}]},{"elementType":"labels.text.stroke","stylers":[{"saturation":-100},{"lightness":100}]},{"featureType":"administrative.locality","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels","stylers":[{"visibility":"on"}]},{"featureType":"water","elementType":"labels","stylers":[{"visibility":"on"}]}]
    # Red Dawn
    # styles = [{"featureType":"water","elementType":"geometry","stylers":[{"color":"#ffdfa6"}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#b52127"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#c5531b"}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#74001b"},{"lightness":-10}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#da3c3c"}]},{"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"color":"#74001b"}]},{"featureType":"road.arterial","elementType":"geometry.stroke","stylers":[{"color":"#da3c3c"}]},{"featureType":"road.local","elementType":"geometry.fill","stylers":[{"color":"#990c19"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#ffffff"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#74001b"},{"lightness":-8}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#6a0d10"},{"visibility":"on"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#ffdfa6"},{"weight":0.4}]},{"featureType":"road.local","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]}]
    twLatlng = new google.maps.LatLng(44.950829, -93.093424)
    myOptions =
        zoom: 14
        center: twLatlng
        mapTypeId: google.maps.MapTypeId.ROADMAP
        mapTypeControl: false
        navigationControl: true
        navigationControlOptions:
            style: google.maps.NavigationControlStyle.ZOOM_PAN
            position: google.maps.ControlPosition.TOP_RIGHT
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
    marker = new google.maps.Marker(
        position: twLatlng
        title: "Tin Whiskers Brewing Company"
    )
    marker.setMap map
    map.setOptions({styles: styles})
    contentString = '<div style="font-weight:700">Tin Whiskers Brewing Company</div> <div style="font-weight:700">125 E 9th St</div> <div style="font-weight:700">St. Paul, MN </div>'
    infowindow = new google.maps.InfoWindow(content: contentString)
    google.maps.event.addListener marker, "click", ->
        infowindow.open map, marker

Template.locationMap.rendered = ->
    if Session.get('gmapsAPInotLoaded')
        #callback for makeGMap is included at end of google maps URL
        Meteor.Loader.loadJs "http://maps.googleapis.com/maps/api/js?v=3&sensor=false&callback=makeGmap"
    else
        makeGmap()

