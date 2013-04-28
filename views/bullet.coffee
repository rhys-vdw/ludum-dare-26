class Game.Bullet
  radius = 0.3
  color = '#FFFFFF'

  constructor: (position, force)->
    @bouncesLeft = 2

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position = position
    bodyDef.mass = 1
    bodyDef.userData = { type: "bullet", entity: @ }

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
    fixtureDef.restitution = 0.02
    fixtureDef.shape = new b2CircleShape radius

    @body = Game.world.CreateBody bodyDef
    @body.CreateFixture fixtureDef

    @body.SetBullet true
    @body.SetLinearVelocity force

    Game.entities.push @

  onContactEnd: (c) ->
    console.log "BOUNCE!"
    @bouncesLeft--

  isDead: ->
    @bouncesLeft == 0

  onDestroy: ->
    console.log "destroyed bullet"
    Game.world.DestroyBody @body

  draw: ->
    pos = @body.GetPosition().Copy()
    pos.Multiply Game.SCALE
    jaws.context.translate pos.x, pos.y
    jaws.context.beginPath()
    jaws.context.arc 0, 0, radius * Game.SCALE, 0, Math.PI*2, true
    jaws.context.closePath()
    jaws.context.fillStyle = color
    jaws.context.fill()
    jaws.context.translate -pos.x, -pos.y
