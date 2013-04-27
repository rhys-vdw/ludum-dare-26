window.Game = {}


class Terrain
  constructor: (segmentCount) ->
    @segmentCount = segmentCount
    @points = []
    @points = (0 for num in [1..segmentCount])
    @

  generateUsingMidPoint: (maxElevation, sharpness) ->
    @midPoint(0, @segmentCount, maxElevation, sharpness)
    @

  midPoint: (start, end, maxElevation, sharpness) ->
    middle = Math.round((start + end) * 0.5)
    return if ((end-start<=1) || middle==start || middle==end)
    newAltitude = 0.5 * (@points[end-1] + @points[start]) + maxElevation*(1 - 2*Math.random())
    @points[middle] = newAltitude
    @midPoint(start, middle, maxElevation*sharpness, sharpness)
    @midPoint(middle, end, maxElevation*sharpness, sharpness)
    @

terrain = new Terrain(40)
terrain.generateUsingMidPoint(2, 1)
console.dir terrain.points
