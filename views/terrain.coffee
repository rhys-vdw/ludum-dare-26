class Game.Terrain
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

  extend: (extendByCount) ->
    segmentCount = @segmentCount
    @segmentCount += extendByCount
    # FIXME: hardcoded maxElevation and sharpness
    @midPoint(segmentCount-1, @segmentCount-1, 1, 1)
