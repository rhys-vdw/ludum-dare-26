FROMTOP = 40
TERRAIN_PREDRAW_THRESH = 80

class Game.Terrain
  constructor: ->
    @points = [FROMTOP]
    @segments = []
    @stepWidth = 3
    @segmentGroupLength = 30
    @displacement = 1
    @extend()

  update: ->
    if jaws.game_state.camera.viewport.x + jaws.game_state.camera.viewport.width + TERRAIN_PREDRAW_THRESH > @x * Game.SCALE
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
    pointsCount = @points.length
    # Stub the new points as average distance from top
    @points[pointsCount..pointsCount+@segmentGroupLength] = (FROMTOP for num in [1..@segmentGroupLength])
    # Augment points with midpoint displacement
    @midPoint(pointsCount-1, @points.length-1, @displacement, 0.50)
    # Create segments
    @createSegments @points[pointsCount-1..], @stepWidth, pointsCount-1
    
    # Teardown old segments
    ###
    if @segments.length > 200
      console.log 'teardown'
      teardownSegments = @segments[0..@segmentGroupLength]
      @segments = @segments[(@segmentGroupLength+1)..]
      #TODO: Also trim the @points array
      #@points = @points[(@segmentGroupLength+1)..]
      for segment in teardownSegments
        Game.world.DestroyBody segment
    ###

    console.log "Segments is #{@segments.length} long"
    console.log "Points is #{@points.length} long"

  createSegments: (heights, stepWidth, startFrom) ->
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

