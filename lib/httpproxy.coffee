HTTP = require 'http'
URL = require 'url'
PATH = require 'path'

promise = require 'node-promise'
qs = require 'querystring'

merge = (require './utils').merge
Cookies = (require './cookie').Cookies

debug = (msg) -> console.log(msg)
#debug = () ->

###
	Proxy will work as httpClient, but keep Simple cookie, and use promise mode
###
class Proxy
	proxy: (name, ip, port) ->
		if (ip)
			@domains[name] = new Client {
				name: name, 
				hostname: ip, 
				port: port or 80, 
				headers: merge({}, @headers) }
		else
			@domains[name]
	parse: (targetUrl) -> 
		target = URL.parse targetUrl
		proxy = @proxy target.hostname
		if not proxy
			throw new Error('Unknown proxy #{target.hostname} for #{targetUrl}')
		proxy.parse target 
	constructor: ->
		@domains = {}
		@headers = {
			'accept-language': 'zh-CN,zh,utf-8;q=0.8,en;q=0.6'
			'accept-encoding': 'gzip,deflate'
			'user-agent': 'Node Http Proxy'
			'accept': '*/*'
			#'accept': 'text/html,application/xhtml+xml,application/xml,application/json;q=0.9,image/webp,*/*;q=0.8'
			#'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) '+
			#	'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
		}
	userAgent: (val) ->
		@headers['user-agent'] = val

class Request
	constructor: (@client, @options, @data) -> @init()
	init: ->
		debug(@options)
		@buffers = []
		@promise = promise.defer()
		@request = HTTP.request @options
		@request.on 'response', @onResponse
		@request.on 'error', @onError
		@sended = false
	then: (s, f) -> @promise.promise.then(s, f)
	send: -> 
		if @sended then throw new Error('has sended')
		@sended = true
		# post data
		if @options.method is 'POST' and @data? then @request.write(@data)
		@request.end()
		@promise.promise
	onError: (e) =>
		debug e
		@promise.reject e
	onResponse: (response) => 
		@response = response
		@statusCode = @response.statusCode
		#debug(response.headers)
		@client.onResponse(@response)
		@response.on 'data', @onData 
		@response.on 'end', @onReponseEnd
		# process other status directly
		#@otherStatus() if not @isOkay()
		@otherStatus() unless @isOkay()
		this
	onData: (data) => 
		#debug 'RCV '+data.length
		@buffers.push data
	onReponseEnd: => 
		#debug 'response ready'
		@body = @buffers.map((x)-> x.toString()).join('')
		# only OK
		@promise.resolve(this) if @isOkay() 
	otherStatus: ->
		switch (@statusCode)
			when 301 then @redirect()
			when 301 then @redirect()
			else @promise.reject(this)
	isOkay: -> @statusCode is 200 or @statusCode is '200' 
	redirect: -> df.reject(this)

class Client
	constructor: (@options = {}) -> @cookies = new Cookies
	clean: -> @cookies = {}
	userAgent: (val) -> @headers['user-agent'] = val
	cookie: (name, value) ->
		if value? then @cookies.add({name: name, value: value})
		@cookies.get(name)?.value
	parse: (target) -> 
		#target.hostname = @options.hostname
		#target.port = @options.port
		# setting heads
		# user-agent, cookies, Forward-Ip-For?
		if not target.headers? then target.headers = {}
		merge(target.headers, @options.headers)
		if not @cookies.isEmpty then target.headers.cookie = @cookies.toString()
		debug target.headers.cookie
		target
	onResponse: (res) -> 
		
		@cookies.read(res)
	send: (method, path, data) ->
		curl = @url path
		target = @parse URL.parse curl
		target.method = method.toUpperCase()
		request = new Request(this, target, data)
		request.send()
	url: (path='/', protocol='http') -> "#{protocol}://#{@options.hostname}:#{@options.port}#{path}"
	get: (path) -> @send('get', path)
	post: (path, data) -> @send('post', path, data)
	postForm: (path, obj) -> @send('post', path, qs.stringify(obj))
	postJson: (path, obj) -> @send('post', path, JSON.stringify(obj))

###
class PathClient extends Client
	constructor: (client, path) ->
		super(client.options)
		@_client = client
###
exports.Client = Client #only for test
exports.dataMerge = merge #only for test
exports.Proxy = Proxy
exports.manager = new Proxy	#global instance for easy use

