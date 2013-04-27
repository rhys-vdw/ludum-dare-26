$ ->
  window.canvas = $('#game')[0]
  window.ctx = canvas.getContext('2d')
  jaws.start Game.state, fps: 30


createSegment = (xa, ya, xb, yb) ->
  xDelta = xb - xa
  yDelta = yb - ya

  bodyDef = new b2BodyDef
  bodyDef.type = b2Body.b2_staticBody
  bodyDef.position.x = xa + xDelta / 2
  bodyDef.position.y = ya + yDelta / 2

  length = Math.sqrt xDelta * xDelta + yDelta * yDelta
  rotation = Math.atan yDelta / xDelta
  
  groundFixtureDef = new b2FixtureDef
  groundFixtureDef.density = 1.0
  groundFixtureDef.friction = 0.5
  groundFixtureDef.restitution = 0.2

  groundFixtureDef.shape = new b2PolygonShape
  groundFixtureDef.shape.SetAsOrientedBox length / 2, 0.15, new b2Vec2(0, 0), rotation
  Game.world.CreateBody(bodyDef).CreateFixture(groundFixtureDef)


createGround = (heights, stepWidth) ->
  for i in [1...heights.length]
    xa = stepWidth * (i - 1)
    ya = heights[i - 1]
    xb = stepWidth * i
    yb = heights[i]
    createSegment xa, ya, xb, yb




Game.deltaTime = ->
  jaws.game_loop.tick_duration / 1000

Game.state = ->
  setup: ->
    gravity = new b2Vec2 0, 10
    Game.world = new b2World gravity, true

    SCALE = 30

    fixDef = new b2FixtureDef
    fixDef.density = 1.0
    fixDef.friction = 0.5
    fixDef.restitution = 0.2

    # create ground
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    bodyDef.position.x = canvas.width / 2 / SCALE
    bodyDef.position.y = canvas.height / SCALE

    fixDef.shape = new b2PolygonShape
    fixDef.shape.SetAsBox( 600 / SCALE / 2, 10 / SCALE / 2)
    Game.world.CreateBody(bodyDef).CreateFixture(fixDef)

    terrain = new Game.Terrain(80)
    terrain.generateUsingMidPoint(1, 1)
    createGround terrain.points, 1
    Game.tank = new Game.Tank 1, 4

    #setup debug draw
    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite ctx
    debugDraw.SetDrawScale SCALE
    debugDraw.SetFillAlpha 0.3
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    Game.world.SetDebugDraw debugDraw

  update: ->
    Game.world.Step Game.deltaTime(), 10, 10
    Game.world.DrawDebugData()
    Game.world.ClearForces()
    Game.tank.update()

  draw: ->

