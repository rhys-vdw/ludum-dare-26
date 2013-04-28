class Game.Item
  constructor: ->
    @isMouseDown = false
    @width = 1
    @height = 1
    jaws.canvas.addEventListener "mousedown", @handleMouseDown, true
    jaws.canvas.addEventListener "mouseup", @handleMouseUp, true

    
  handleMouseDown: (e) =>
    console.log 'mouseDownHandler'
    @isMouseDown = true

    # Create object under cursor
    position = jaws.game_state.camera.screenToWorldPosition(new b2Vec2(e.clientX - jaws.canvas.getBoundingClientRect().left, e.clientY - jaws.canvas.getBoundingClientRect().top))
    @createObject(position)


    # Update the position on mouseMove
    @handleMouseMove(e)
    document.addEventListener("mousemove", @handleMouseMove, true)

  handleMouseUp: (e) =>
    document.removeEventListener("mousemove", @handleMouseMove, true)
    @isMouseDown = false

  handleMouseMove: (e) =>
    console.count 'move'
    position = jaws.game_state.camera.screenToWorldPosition(new b2Vec2(e.clientX - jaws.canvas.getBoundingClientRect().left, e.clientY - jaws.canvas.getBoundingClientRect().top))
    @body.SetPosition(position)

  createObject: (position) =>
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_kinematicBody
    bodyDef.position.Set(position.x, position.y)

    groundFixtureDef = new b2FixtureDef
    groundFixtureDef.density = 1.0
    groundFixtureDef.friction = 0.2
    groundFixtureDef.restitution = 0.05
    groundFixtureDef.shape = new b2PolygonShape
    groundFixtureDef.shape.SetAsBox @width/2, @height/2

    @body = Game.world.CreateBody(bodyDef)
    @body.CreateFixture(groundFixtureDef)
