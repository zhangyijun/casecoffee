describe 'http-proxy', ->

  it 'jasmine ready', ->
    expect(1+2).toEqual(3)

  it 'http-proxy loaded', ->
    proxy = require '../lib/httpproxy.coffee'
    expect(proxy).not.toBeUndefined()
    expect(proxy).not.toBeNull()

  it 'http-proxy Create', ->
    Proxy = require('../lib/httpproxy').Proxy
    proxy = new Proxy

  it 'http-proxy cookie ready', ->
    Proxy = require('../lib/httpproxy').Proxy
    proxy = new Proxy {host: 'localhost', port: '8080'}
    expect(proxy).not.toBeNull()
    expect(proxy.cookie).not.toBeNull()
    expect(proxy.cookie 'xyz' ).toBeUndefined()
    expect(proxy.cookie 'xyz', '123').toBe('123')
    expect(proxy.cookie 'xyz').toBe('123')

###  
  it 'Async OK', ->
    setTimeout ->
      expect 'second' toEqual 'second'
      asyncSpecDone(), 1

    expect 'first'  toEqual 'first'
    asyncSpecWait();


  it('Node Asyn OK', (done) ->
    setTimeout ->
      expect('second').toEqual('second')
      # If you call done() with an argument, it will fail the spec 
      # so you can use it as a handler for many async node calls
      done(), 1

    expect 'first' toEqual 'first'

###

