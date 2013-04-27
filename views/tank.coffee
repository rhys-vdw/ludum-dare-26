class Game.Tank
  width = 1
  height = 0.5

  constructor: (x, y) ->

    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.0
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width, height

    @body = Game.world.CreateBody(bodyDef).CreateFixture(fixtureDef)

  draw: ->
    # TODO(Rhys): Draw the tank derp!
    #Game.context.drawImage @body.position.x, @body.position.y

  update: ->
    console.log jaws.pressed 'd'
    if jaws.pressed 'right'
      console.log 'moving right'
      @body.ApplyForce new b2Vec2( 100, 0 ), new b2Vec2( 0, 0 )



