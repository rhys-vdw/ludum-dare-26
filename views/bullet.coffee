class Game.Bullet
  radius = 0.3
  color = '#FFFFFF'

  constructor: (position, force)->
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position = position
    bodyDef.mass = 1

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2CircleShape radius

    @body = Game.world.CreateBody bodyDef
    @body.CreateFixture fixtureDef

    @body.SetBullet true
    @body.SetLinearVelocity force

    Game.Bullet.all.push @

  update: ->

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

Game.Bullet.all = new jaws.SpriteList()