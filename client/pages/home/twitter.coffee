# TODO: implement re-render protection http://stackoverflow.com/questions/16100123/embed-javascript-widget-in-meteor-template

Template.home.rendered = ->
	d = window.document
	s = "script"
	id = "twitter-wjs"
	js = undefined
	fjs = d.getElementsByTagName(s)[0]
	unless d.getElementById(id)
		js = d.createElement(s)
		js.id = id
		js.src = "//platform.twitter.com/widgets.js"
		fjs.parentNode.insertBefore(js, fjs)
