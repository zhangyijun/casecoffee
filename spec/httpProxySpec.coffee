describe 'http-proxy', ->

  notExpect = (o) -> expect(o).not
  noit = (descr, func) -> descr

  it 'jasmine ready', ->
    expect(1+2).toEqual(3)

  it 'http-proxy loaded', ->
    proxy = require '../lib/httpproxy'
    expect(proxy).not.toBeUndefined()
    expect(proxy).not.toBeNull()

  it 'http-proxy Create', ->
    Client = require('../lib/httpproxy').Client
    client = new Client

  it 'http-proxy cookie ready', ->
    Client = require('../lib/httpproxy').Client
    client = new Client {host: 'localhost', port: '8080'}
    expect(client).not.toBeNull()
    expect(client.cookie).not.toBeNull()
    expect(client.cookie 'xyz' ).toBeUndefined()
    expect(client.cookie 'xyz', '123').toBe('123')
    expect(client.cookie 'xyz').toBe('123')

  #console.log '\nPractice'
  noit 'coffee pratice', ->
    show = (msg) ->
      console.log(msg)
    #show n for n in [0..20]
    #for n in [0..20] by 2 then show n
    for n in [0..20] by 2
      if n % 4 == 0
        show n

  it 'simple use', ->
    manager = require('../lib/httpproxy').manager
    testApp = manager.proxy('test.com', 'localhost', 80)
    testApp.get('/store0/').then ( -> ), (res)->
      console.log(res.statusCode)
      testApp.get('/assets/bootstrap/css/bootstrap.min.css').then((res)->
          console.log(res.statusCode)
          console.log(res.body.length)
          #console.log(res)
        ).then( ()-> 
          console.log 'async Spec End.'
          #asyncSpecDone()
        )
    #asyncSpecWait();
#    testApp.postForm('/', {}).then((res) ->
#      console.log(res))
#    testApp.postJson('/', {}).then((res) ->
#      console.log(res))


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

