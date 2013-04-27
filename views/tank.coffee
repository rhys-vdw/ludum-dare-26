class Game.Tank
  width = 1
  height = 0.5

  constructor: (x, y) ->
    @drivingForce = 1000

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.4
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width, height

    @body = Game.world.CreateBody(bodyDef)
    @body.CreateFixture(fixtureDef)

  draw: ->
    # TODO(Rhys): Draw the tank derp!
    #Game.context.drawImage @body.position.x, @body.position.y

  update: ->
    #if jaws.pressed 'right'
    @body.ApplyForce new b2Vec2( @drivingForce * Game.deltaTime(), 0 ), @body.GetPosition()



