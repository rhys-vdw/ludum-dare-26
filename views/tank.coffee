class Game.Tank
  width = 1
  height = 0.2
  clearance = -0.2
  wheelCount = 2
  wheelRadius = 0.4

  createTank: (x, y) ->

    # Tank body.
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y
    bodyDef.mass = 1

    # Create box for a shell.
    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.4
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width / 2, height / 2

    @body = Game.world.CreateBody bodyDef
    @body.CreateFixture fixtureDef

    # Now lets add some wheels.
    wheelSpacing = width / (wheelCount - 1)
    @wheels = []
    @motors = []
    for i in [0...wheelCount]
      wheelPos = new b2Vec2 x - width / 2 + wheelSpacing * i, y + height / 2 + clearance
      console.log wheelPos
      bodyDef.position = wheelPos
      bodyDef.mass = 10
      fixtureDef.shape = new b2CircleShape wheelRadius
      fixtureDef.restitution = 0
      fixtureDef.friction = Infinity

      wheel = Game.world.CreateBody bodyDef
      wheel.CreateFixture fixtureDef

      motorDef = new b2RevoluteJointDef
      motorDef.Initialize @body, wheel, wheelPos
      motorDef.enableMotor = true
      motorDef.motorSpeed = 10
      motorDef.maxMotorTorque = Infinity

      motor = Game.world.CreateJoint motorDef

      console.log motorDef, motor

      @wheels.push wheel
      @motors.push motor


  constructor: (x, y) ->
    @drivingForce = 1000

    @createTank(x, y)


  draw: ->
    # TODO(Rhys): Draw the tank derp!
    #Game.context.drawImage @body.position.x, @body.position.y

  update: ->
    #if jaws.pressed 'right'
    #@body.ApplyForce new b2Vec2( @drivingForce * Game.deltaTime(), 0 ), @body.GetPosition()



