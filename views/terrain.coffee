FROMTOP = 40
class Game.Terrain
  constructor: ->
    @points = [FROMTOP]
    @segments = []
    @stepWidth = 3
    @segmentGroupLength = 80
    @displacement = 30
    @extend()

  draw: ->
    ctx = jaws.context
    ctx.scale(Game.SCALE, Game.SCALE)
    ctx.fillStyle = "black"
    ctx.beginPath()
    ctx.moveTo 0, @points[0]
    for point, i in @points
      ctx.lineTo(i*@stepWidth, point)
    ctx.lineTo(@points.length*@stepWidth, 250)
    ctx.lineTo(0, 250)
    ctx.fill()
    ctx.scale(1/Game.SCALE, 1/Game.SCALE)

  midPoint: (start, end, maxElevation, sharpness) ->
    middle = Math.round((start + end) * 0.5)
    return if ((end-start<=1) || middle==start || middle==end)
    newAltitude = 0.5 * (@points[end] + @points[start]) + maxElevation*(1 - 2*Math.random())
    @points[middle] = newAltitude
    @midPoint(start, middle, maxElevation*sharpness, sharpness)
    @midPoint(middle, end, maxElevation*sharpness, sharpness)

  extend: ->
    segmentCount = @segmentCount()
    @points[segmentCount..segmentCount+@segmentGroupLength] = (FROMTOP for num in [1..@segmentGroupLength])
    @midPoint(segmentCount-1, @segmentCount()-1, @displacement, 0.50)
    @createGround @points[segmentCount-1..@segmentCount-1], @stepWidth, segmentCount-1
    #TODO: trash old points
    console.log "Array is #{@segmentCount()} long"

  createGround: (heights, stepWidth, startFrom) ->
    for i in [1...heights.length]
      xa = stepWidth * (i - 1 + startFrom)
      ya = heights[i - 1]
      xb = stepWidth * (i + startFrom)
      yb = heights[i]
      @segments.push @createSegment xa, ya, xb, yb
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
    body = Game.world.CreateBody(bodyDef)
    body.CreateFixture(groundFixtureDef)
    body

  segmentCount: -> @points.length


