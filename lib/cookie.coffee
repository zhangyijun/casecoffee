merge = (require './utils').merge

class Cookie
	constructor: (val) ->
		if typeof val is 'string'
			merge(this, @parse(val))
		else
			merge(this, val)
	toString: -> "#{@name}=#{@value}"
	parse: (string) -> 
		pairs = @pairs string
		[@name, @value] = @keyvalue pairs[0]
		for pair in pairs.slice(1)
			[key, value] = @keyvalue pair
			if not value? then value = true #Tag setting, need check ?
			this[key] = value
		@validate()
	validate: -> 
		if not @name? or not @value?
			throw new Error('name and value Required: '+@toString())
	keyvalue: (string) -> string.split '='
	pairs: (string) -> string.split /;\s?/

class Cookies
	constructor: -> @cookies = []
	toString: ->
		data = {}	#as map
		for value in @cookies then data[value.name] = value
		results = []
		for key, value of data then results.push(value.toString());
		results.join '; '
	get: (name) -> 
		rs = null
		for value in @cookies
			if value.name is name then rs = value;
		rs
	add: (cookie) -> @cookies.push cookie
	read: (res) ->
		rs = res?.headers?['set-cookie']
		if rs
			#console.log(rs)
			if Array.isArray(rs)
				for value in rs then @add new Cookie(value)
			else
				@add new Cookie(rs)
		#console.log(this)
		res
	isEmpty: -> @cookies.length is 0

#merge exports, {Cookies: Cookies, Cookie: Cookie}
exports.Cookie = Cookie
exports.Cookies = Cookies


