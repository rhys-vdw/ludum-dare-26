jaws.assets.add 'sprites/tank.png'
Game.SCALE = 20

$ ->
  jaws.start Game.state, fps: 60


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
  groundFixtureDef.friction = 0.2
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
    gravity = new b2Vec2 0, 18
    Game.world = new b2World gravity, true

    # Create Terrain
    terrain = new Game.Terrain(1000)
    terrain.generateUsingMidPoint(1, 1)
    createGround terrain.points, 1
    Game.tank = new Game.Tank 1, 4

    #setup debug draw
    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite jaws.context
    debugDraw.SetDrawScale Game.SCALE
    debugDraw.SetFillAlpha 0.3
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    Game.world.SetDebugDraw debugDraw

    # Setup viewport
    @viewport = new jaws.Viewport({max_x: 12000, max_y: 480})

  update: ->
    Game.world.Step Game.deltaTime(), 10, 10
    Game.world.ClearForces()
    Game.tank.update()
    @viewport.centerAround Game.tank

  draw: ->
    jaws.clear()
    @viewport.apply ->
      Game.world.DrawDebugData()
      Game.tank.draw()
