class Game.Hud
  constructor: ->
    @width = 500
    @height = 80
    @fromTop = 20
    @ctx = jaws.context
    @setHudPos()
    @rect = new jaws.Rect(@xywh...)

    @jumpItem = new Game.Item

    #jaws.on_keydown 'left_mouse_button', @mouseDown


  update: ->
  ###

  mouseDown: (e) =>
    console.log "mousedown at #{window.event.x}, #{window.event.y}"
    if @rect.collidePoint(window.event.x, window.event.y)
      jaws.on_keyup 'left_mouse_button', @mouseUp
  mouseUp: (e) =>
    jaws.on_keyup 'left_mouse_button', null
    console.log "mouseup at #{window.event.x}, #{window.event.y}"

    @fromTop = window.event.y
    @setHudPos()
  ###

  draw: ->
    @ctx.fillStyle = 'rgba(0,0,0,0.2)'
    @ctx.beginPath()
    @ctx.rect(@xywh...)
    @ctx.fill()
    @rect.draw()
    
  setHudPos: ->
    @xywh = [@ctx.canvas.width/2-(@width/2), @fromTop ,@width, @height]
