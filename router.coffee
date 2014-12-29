  
#################################################################
#       Routes
#################################################################
Router.map ->
  @route 'store',
    where: 'server'
    onBeforeAction: ->
      this.response.writeHead 301,
        Location: "http://store.twbrewing.com"
      this.response.end()