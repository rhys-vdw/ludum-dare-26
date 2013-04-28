class Game.Hud
  constructor: ->
    @width = 500
    @height = 80
    @fromTop = 20
    @ctx = jaws.context
    @setHudPos()
    
    @rect = new jaws.Rect(@xywh...)

    #jaws.on_keydown 'left_mouse_button', @mouseDown

    jaws.canvas.addEventListener "mousedown", (e) =>
       @isMouseDown = true
       @handleMouseMove(e)
       document.addEventListener("mousemove", @handleMouseMove, true)
    , true
    
    jaws.canvas.addEventListener "mouseup", (e) =>
       document.removeEventListener("mousemove", @handleMouseMove, true)
       @isMouseDown = false
       @mouseX = undefined
       @mouseY = undefined
    , true
    
  handleMouseMove: (e) =>
    @mouseX = (e.clientX - jaws.canvas.getBoundingClientRect().left) / Game.SCALE
    @mouseY = (e.clientY - jaws.canvas.getBoundingClientRect().top) / Game.SCALE
    console.log @mouseX, @mouseY

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
