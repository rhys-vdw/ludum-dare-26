class Game.Hud
  constructor: ->
    @width = 80
    @height = 80
    @fromTop = 20
    @ctx = jaws.context
    @xywh = [@ctx.canvas.width/2-(@width/2), @fromTop ,@width, @height]

    @jumpBucket = new jaws.Rect(@xywh...)
    @jumpItem = new Game.Item

    jaws.on_keydown 'left_mouse_button', @mouseDown


  update: ->

  mouseDown: (e) =>
    console.log "mousedown at #{window.event.x}, #{window.event.y}"

    if @jumpBucket.collidePoint(window.event.x, window.event.y)
      @jumpItem.handleMouseDown(window.event)
    #elseif @otherBucket.collidePoint...

  draw: ->
    @ctx.fillStyle = 'rgba(0,0,0,0.2)'
    @ctx.beginPath()
    @ctx.rect(@xywh...)
    @ctx.fill()
    @jumpBucket.draw()
