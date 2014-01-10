http = require 'http'
url = require 'url'
promise = require 'node-promise'

class Proxy
	constructor: (@options = {}) ->
		@cookies = {}

	cookie: (name, value) ->
		if value?
			@cookies[name]=value
		else 
			@cookies[name]

exports.Proxy = Proxy

