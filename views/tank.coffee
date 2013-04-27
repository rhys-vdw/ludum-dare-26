class Game.Tank
  width = 1
  height = 0.5

  constructor: (x, y) ->
    @drivingForce = 1400
    @x = x*Game.SCALE
    @y = y*Game.SCALE

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width, height

    @body = Game.world.CreateBody(bodyDef)
    @body.CreateFixture(fixtureDef)
    @sprite = new jaws.Sprite {image: "sprites/tank.png", x: 0, y: 0, scale: 1, anchor: "center"}

  draw: ->
    jaws.context.save()
    jaws.context.translate @x, @y
    jaws.context.rotate @body.GetAngle()
    @sprite.draw()
    jaws.context.restore()

  update: ->
    @body.ApplyForce new b2Vec2( @drivingForce * Game.deltaTime(), 0 ), @body.GetPosition()
    @x = @body.GetPosition().x * Game.SCALE
    @y = @body.GetPosition().y * Game.SCALE
