class Terrain
  constructor: (segmentCount) ->
    @segmentCount = segmentCount
    @points = (8 for num in [1..segmentCount])

  generateUsingMidPoint: (maxElevation, sharpness) ->
    @midPoint(0, @segmentCount-1, maxElevation, sharpness)

  midPoint: (start, end, maxElevation, sharpness) ->
    middle = Math.round((start + end) * 0.5)
    return if ((end-start<=1) || middle==start || middle==end)
    newAltitude = 0.5 * (@points[end] + @points[start]) + maxElevation*(1 - 2*Math.random())
    @points[middle] = newAltitude
    @midPoint(start, middle, maxElevation*sharpness, sharpness)
    @midPoint(middle, end, maxElevation*sharpness, sharpness)

  extend: (extendbycount) ->
    console.log 'do it'

terrain = new Terrain(80)
terrain.generateUsingMidPoint(1, 1)


$ ->
  canvas = $('#game')[0]
  ctx = canvas.getContext('2d')

  groundFixtureDef = new b2FixtureDef
  groundFixtureDef.density = 1.0
  groundFixtureDef.friction = 0.5
  groundFixtureDef.restitution = 0.2

  RAD_TO_DEG = 180 / Math.PI

  world = null
  createSegment = (xa, ya, xb, yb) ->
    xDelta = xb - xa
    yDelta = yb - ya

    #console.log xa + xDelta / 2, ya + yDelta / 2
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    bodyDef.position.x = xa + xDelta / 2
    bodyDef.position.y = ya + yDelta / 2

    length = Math.sqrt xDelta * xDelta + yDelta * yDelta
    rotation = Math.atan yDelta / xDelta
    
    groundFixtureDef.shape = new b2PolygonShape
    groundFixtureDef.shape.SetAsOrientedBox length / 2, 0.15, new b2Vec2(0, 0), rotation
    world.CreateBody(bodyDef).CreateFixture(groundFixtureDef)


  createGround = (heights, stepWidth) ->
    for i in [1...heights.length]
      xa = stepWidth * (i - 1)
      ya = heights[i - 1]
      xb = stepWidth * i
      yb = heights[i]
      createSegment xa, ya, xb, yb

  init = ->
     gravity = new b2Vec2 0, 10
     sleep = true
     world = new b2World gravity, sleep
     
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
     world.CreateBody(bodyDef).CreateFixture(fixDef)
   
     createGround terrain.points, 1

     # create some objects
     ###
     bodyDef.type = b2Body.b2_dynamicBody
     for i in [0...1]
        if Math.random() > 0.5
           fixDef.shape = new b2PolygonShape
           fixDef.shape.SetAsBox Math.random() + 0.1, Math.random() + 0.1
        else
           fixDef.shape = new b2CircleShape Math.random() + 0.1
        bodyDef.position.x = Math.random() * 25
        bodyDef.position.y = Math.random() * 10
        world.CreateBody(bodyDef).CreateFixture(fixDef)
###
   
     #setup debug draw
     debugDraw = new b2DebugDraw()
     debugDraw.SetSprite ctx
     debugDraw.SetDrawScale SCALE
     debugDraw.SetFillAlpha 0.3
     debugDraw.SetLineThickness 1.0
     debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
     world.SetDebugDraw debugDraw
   
   update = ->
     world.Step 1 / 60, 10, 10
     world.DrawDebugData()
     world.ClearForces()
   
     requestAnimFrame(update)

  init()
  requestAnimFrame(update)
