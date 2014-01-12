describe 'Cookie', ->
	noit = (descr, func) -> descr
	cookie = require '../lib/cookie'
	Cookie = cookie.Cookie

	it 'cookie create directly', ->
		c = new cookie.Cookie {name: 'sid', value: 'xxx'}
		expect(c.name).toBe 'sid'
		expect(c.value).toBe 'xxx'

	it 'cookie create from string', ->
		c = new cookie.Cookie 'sid=xxx; path=/; domain=*.text.com; secure; HttpOnly'
		expect(c.name).toBe 'sid'
		expect(c.value).toBe 'xxx'
		expect(c.secure).toBeTruthy()
		expect(c.HttpOnly).toBeTruthy()

	it 'cookies get', ->
		cs = new cookie.Cookies
		cs.add (new Cookie {name: 'sid', value: 'xxx'})
		cs.add (new Cookie {name: 'email', value: 'x@x.com'})
		cs.add (new Cookie {name: 'sid', value: 'new'})

		expect(cs.get('email').value).toBe 'x@x.com'
		expect(cs.get('sid').value).toBe 'new'

		expect(cs.toString()).toEqual 'sid=new; email=x@x.com'

	it 'cookies read by object', ->
		cs = new cookie.Cookies
		cs.read {headers: {'set-cookie': 'email=x@x.com; path=/'}}
		expect(cs.get('email').value).toEqual('x@x.com') 

	it 'cookies read by array', ->
		cs = new cookie.Cookies
		cs.read {headers: {'set-cookie': ['email=x@x.com; path=/', 'nick=bob']}}
		expect(cs.get('email').value).toEqual('x@x.com') 
		expect(cs.get('nick').value).toEqual('bob') 


