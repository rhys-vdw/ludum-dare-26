class Game.Hud
  constructor: ->
    @width = 80
    @height = 80
    @fromTop = 20
    @ctx = jaws.context

    # Jump
    @jumpBucketPosition = [@ctx.canvas.width/2-(@width/2) - 50, @fromTop ,@width, @height]
    @jumpBucket = new jaws.Rect(@jumpBucketPosition...)
    @jumpItem = new Game.JumpItem
    # Bullet
    @bulletBucketPosition = [@ctx.canvas.width/2-(@width/2) + 50, @fromTop ,@width, @height]
    @bulletBucket = new jaws.Rect(@bulletBucketPosition...)
    @bulletItem = new Game.BulletItem

    jaws.on_keydown 'left_mouse_button', @mouseDown


  mouseDown: (e) =>
    if @jumpBucket.collidePoint(window.event.x, window.event.y)
      @jumpItem.handleMouseDown(window.event)
    else if @bulletBucket.collidePoint(window.event.x, window.event.y)
      @bulletItem.handleMouseDown(window.event)

  update: ->

  draw: ->
    @ctx.fillStyle = 'rgba(0,0,0,0.2)'
    @ctx.beginPath()
    @ctx.rect(@jumpBucketPosition...)
    @ctx.fill()
    @jumpBucket.draw()

    @ctx.fillStyle = 'rgba(0,200,50,0.2)'
    @ctx.beginPath()
    @ctx.rect(@bulletBucketPosition...)
    @ctx.fill()
    @bulletBucket.draw()
