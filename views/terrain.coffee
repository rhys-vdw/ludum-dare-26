FROMTOP = 14
class Game.Terrain
  constructor: (segmentCount) ->
    @points = [FROMTOP]
    @extendBy(segmentCount)

  generateUsingMidPoint: (maxElevation, sharpness) ->
    @midPoint(0, @segmentCount()-1, maxElevation, sharpness)

  midPoint: (start, end, maxElevation, sharpness) ->
    middle = Math.round((start + end) * 0.5)
    return if ((end-start<=1) || middle==start || middle==end)
    newAltitude = 0.5 * (@points[end] + @points[start]) + maxElevation*(1 - 2*Math.random())
    @points[middle] = newAltitude
    @midPoint(start, middle, maxElevation*sharpness, sharpness)
    @midPoint(middle, end, maxElevation*sharpness, sharpness)

  extendBy: (extendByCount) ->
    segmentCount = @segmentCount()
    @points[segmentCount..segmentCount+extendByCount] = (FROMTOP for num in [1..extendByCount])
    @midPoint(segmentCount-1, @segmentCount()-1, 5, 0.9)
    @createGround @points[segmentCount-1..@segmentCount-1], 5, segmentCount-1
    #TODO: trash old points
    console.log "Array is #{@segmentCount()} long"

  createGround: (heights, stepWidth, startFrom) ->
    for i in [1...heights.length]
      xa = stepWidth * (i - 1 + startFrom)
      ya = heights[i - 1]
      xb = stepWidth * (i + startFrom)
      yb = heights[i]
      @createSegment xa, ya, xb, yb
    @x = xb

  createSegment: (xa, ya, xb, yb) ->
    xDelta = xb - xa
    yDelta = yb - ya

    groundThickness = 1

    length = Math.sqrt xDelta * xDelta + yDelta * yDelta
    rotation = Math.atan yDelta / xDelta
    
    yoffset = xDelta / length * groundThickness
    xoffset = yDelta / length * -groundThickness

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    bodyDef.position.x = xa + xDelta / 2 + xoffset
    bodyDef.position.y = ya + yDelta / 2 + yoffset

    groundFixtureDef = new b2FixtureDef
    groundFixtureDef.density = 1.0
    groundFixtureDef.friction = 0.2
    groundFixtureDef.restitution = 0.2
    groundFixtureDef.shape = new b2PolygonShape
    groundFixtureDef.shape.SetAsOrientedBox length / 2, groundThickness, new b2Vec2(0, 0), rotation
    Game.world.CreateBody(bodyDef).CreateFixture(groundFixtureDef)

  segmentCount: -> @points.length

