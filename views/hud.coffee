class Game.Hud
  constructor: (position, type) ->
    @width = 80
    @height = 80
    @ctx = jaws.context
    @type = type
    @position = [position.x, position.y ,@width, @height]
    @bucketUi = new jaws.Rect(@position...)
    document.addEventListener("mousedown", @mouseDown, true)

  mouseDown: (e) =>
    if @bucketUi.collidePoint(window.event.x, window.event.y)
      @item = new @type
      @item.handleMouseDown(window.event)

  draw: =>
    @ctx.fillStyle = 'rgba(0,0,0,0.2)'
    @ctx.beginPath()
    @ctx.rect(@position...)
    @ctx.fill()
    @bucketUi.draw()
