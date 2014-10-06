{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'gravatar', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot gravatar m@bouzuya.net'
          matches: ['@hubot gravatar m@bouzuya.net', 'm@bouzuya.net']
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

  describe 'listeners[0].callback', ->
    beforeEach ->
      @gravatar = @robot.listeners[0].callback

    describe 'receive "@hubot gravatar m@bouzuya.net"', ->
      beforeEach ->
        @send = @sinon.spy()
        @gravatar
          match: ['@hubot gravatar m@bouzuya.net', 'm@bouzuya.net']
          send: @send

      it '''
send "http://www.gravatar.com/avatar/9890843c055488de704d85ef1ae1b893"
         ''', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is \
          'http://www.gravatar.com/avatar/9890843c055488de704d85ef1ae1b893'

  describe 'robot.helpCommands()', ->
    it 'should be ["hubot gravatar <email> - returns your gravatar"]', ->
      assert.deepEqual @robot.helpCommands(), [
        "hubot gravatar <email> - returns your gravatar"
      ]
