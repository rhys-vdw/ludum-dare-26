class Game.Item
  constructor: ->
    @width = 1
    @height = 1
    @hasCollided = false
    
  handleMouseDown: (e) =>
    return if @body?
    jaws.canvas.addEventListener "mouseup", @handleMouseUp, true
    # Create object under cursor
    position = jaws.game_state.camera.screenToWorldPosition(new b2Vec2(e.clientX - jaws.canvas.getBoundingClientRect().left, e.clientY - jaws.canvas.getBoundingClientRect().top))
    @createObject(position)
    # Update the position on mouseMove
    @handleMouseMove(e)
    document.addEventListener("mousemove", @handleMouseMove, true)

  handleMouseUp: (e) =>
    document.removeEventListener("mousemove", @handleMouseMove, true)

  handleMouseMove: (e) =>
    position = jaws.game_state.camera.screenToWorldPosition(new b2Vec2(e.clientX - jaws.canvas.getBoundingClientRect().left, e.clientY - jaws.canvas.getBoundingClientRect().top))
    @body.SetPosition(position)

  createObject: (position) =>
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_staticBody
    bodyDef.userData = { type: 'item', entity: @ }
    bodyDef.position.Set(position.x, position.y)

    groundFixtureDef = new b2FixtureDef
    groundFixtureDef.density = 1.0
    groundFixtureDef.friction = 0.2
    groundFixtureDef.restitution = 0.05
    groundFixtureDef.shape = new b2PolygonShape
    groundFixtureDef.shape.SetAsBox @width/2, @height/2
    groundFixtureDef.isSensor = true

    @body = Game.world.CreateBody(bodyDef)
    @sensor = @body.CreateFixture(groundFixtureDef)
    Game.entities.push @


  onContactBegin: (c) =>
    if c.type is 'tank'
      c.entity.jump()
      @hasCollided = true

  isDead: ->
    @hasCollided

  onDestroy: ->
    Game.world.DestroyBody @body
    @body = undefined
    # Reset flag
    @hasCollided = false

  draw: ->
