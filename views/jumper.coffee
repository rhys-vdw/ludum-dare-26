class Game.Jumper
  width = 1
  height = 1

  createBody: (position) ->
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position = position
    bodyDef.mass = 10
    bodyDef.userData = type: "enemy", entity: @

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width / 2, height / 2

    body = Game.world.CreateBody bodyDef
    body.CreateFixture fixtureDef
    return body

  constructor: (options) ->
    @jumpPeriod   = options?.jumpPeriod   ? 10
    @jumpVelocity = options?.jumpVelocity ? 40
    @timeSinceLastJump = 0
    @body = @createBody new b2Vec2( options.x, options.y )
    @sprite = new jaws.Sprite image: "sprites/jumper.png", x: 0, y: 0, anchor: "center"

    Game.entities.push @

  update: ->
    @timeSinceLastJump += Game.deltaTime()
    if @timeSinceLastJump > @jumpPeriod
      @timeSinceLastJump = 0
      @jump()

  draw: ->
    pos = @body.GetPosition()
    jaws.context.save()
    jaws.context.translate pos.x * Game.SCALE, pos.y * Game.SCALE 
    jaws.context.rotate @body.GetAngle()
    @sprite.draw()
    jaws.context.restore()

  onContactBegin: (c) ->
    if c?.type? && c.type == "ground"
      @isGrounded = true

  onContactEnd: (c) ->
    if c?.type? && c.type == "ground"
      @isGrounded = false

  jump: ->
    if @isGrounded
      v = @body.GetLinearVelocity()
      v.Add new b2Vec2 0, -@jumpVelocity
      @body.SetLinearVelocity v

  isDead: ->
    @body.GetPosition.y > 200

  onDestroy: ->
    Game.world.DestroyBody @body
