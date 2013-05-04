class Game.Tank
  width = 5
  height = 0.2
  clearance = 1
  wheelCount = 5
  wheelRadius = 0.4
  baseMotorSpeed = 20
  baseMotorTorque = 50
  boostMotorSpeed = 60
  boostMotorTorque = 100

  createTank: (x, y) ->

    # Tank body.
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y
    bodyDef.mass = 200
    bodyDef.userData = { type: "tank", entity: @ }

    # Create box for a shell.
    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox width / 2, height / 2

    @body = Game.world.CreateBody bodyDef
    @body.CreateFixture fixtureDef
    
    # Gun
    @gun = new Game.Gun { force: 30000, attachment: @body, fireDelay: 0.01 }

    # Now lets add some wheels.
    wheelSpacing = width / (wheelCount - 1)
    @wheels = []
    @motors = []
    for i in [0...wheelCount]
      lift = if i == 0 or i == wheelCount-1 then -0.2 else 0
      wheelPos = new b2Vec2 x - width / 2 + wheelSpacing * i, y + height / 2 + clearance + lift
      bodyDef.position = wheelPos
      bodyDef.mass = 10
      bodyDef.userData = { type: "tank", entity: @ }
      fixtureDef.shape = new b2CircleShape wheelRadius
      fixtureDef.restitution = 0
      fixtureDef.friction = 100

      wheel = Game.world.CreateBody bodyDef
      wheel.CreateFixture fixtureDef

      bodyDef.position = wheelPos
      fixtureDef.shape = new b2PolygonShape
      fixtureDef.shape.SetAsBox wheelRadius/2, wheelRadius/2
      axle = Game.world.CreateBody bodyDef
      axle.CreateFixture fixtureDef

      # Wheel to axle
      motorDef = new b2RevoluteJointDef
      motorDef.Initialize axle, wheel, wheelPos
      motorDef.enableMotor = true
      motorDef.motorSpeed = 20
      motorDef.maxMotorTorque = 50
      motor = Game.world.CreateJoint motorDef

      # Axle to body
      springDef = new b2PrismaticJointDef
      springDef.lowerTranslation = -0.3
      springDef.upperTranslation = 0
      springDef.enableLimit = true
      springDef.limi = true
      springDef.enableMotor = true
      springDef.maxMotorForce = 8
      springDef.motorSpeed = 4
      pos = wheelPos.Copy()
      springDef.Initialize @body, axle, pos, new b2Vec2(0,1)
      spring = Game.world.CreateJoint springDef

      @wheels.push wheel
      @motors.push motor

  Rad2Deg = 180 / Math.PI

  constructor: (x, y) ->
    @groundedWheelCount = 0
    @gunOffset = new b2Vec2 2, -2
    @x = x
    @y = y
    @createTank(x, y)
    @sprite = new jaws.Sprite {image: "sprites/tank.png", x: 0, y: -10, scale: 2.5, anchor: "center"}
    @wheelSprites = []
    for wheel in @wheels
      pos = wheel.GetPosition()
      wheel.sprite = new jaws.Sprite( { image: "sprites/wheel-8.png", x: 0, y: 0, anchor:"center", scale: 3 } )


    jaws.on_keydown 'period', @jump
    jaws.on_keydown 'z', @boostStart
    jaws.on_keyup   'z', @boostEnd
    Game.entities.push @


  onContactBegin: (c) ->
    if c?.type? && c.type == "ground"
      @groundedWheelCount++
      @isGrounded = @groundedWheelCount > 0

  onContactEnd: (c) ->
    if c?.type? && c.type == "ground"
      @groundedWheelCount--
      @isGrounded = @groundedWheelCount > 0

  boostStart: =>
    console.log "boost start"
    @setMotorSpeed boostMotorSpeed, boostMotorTorque

  boostEnd: =>
    console.log "boost end"
    @setMotorSpeed baseMotorSpeed, baseMotorTorque

  setMotorSpeed: (speed, torque) ->
    for motor in @motors
      motor.SetMotorSpeed speed
      motor.SetMaxMotorTorque torque

  jump: =>
    if @isGrounded
      v = @body.GetLinearVelocity()
      v.Add new b2Vec2 0, -100
      @body.SetLinearVelocity v

  draw: ->
    for wheel in @wheels
      pos = wheel.GetPosition()
      jaws.context.save()
      jaws.context.translate pos.x * Game.SCALE, pos.y * Game.SCALE
      jaws.context.rotate wheel.GetAngle()
      wheel.sprite.draw()
      jaws.context.restore()

    # Move to tank center
    jaws.context.save()
    jaws.context.translate @x * Game.SCALE, @y * Game.SCALE

    # Rotate and draw tank
    jaws.context.save()
    jaws.context.rotate @body.GetAngle()
    @sprite.draw()

    # Draw that red line for showing gun pos.
    ###
    gunPos = @gunPosition()
    gunPos.Multiply Game.SCALE
    forward = @forwardVector()
    forward.Multiply 300

    line = gunPos.Copy()
    line.Add forward

    # Unrotate first...
    jaws.context.beginPath()
    jaws.context.moveTo gunPos.x, gunPos.y
    jaws.context.lineTo line.x, line.y
    jaws.context.strokeStyle = 'rgba(255, 0, 0, 0.2)'
    jaws.context.stroke()

    ###
    jaws.context.restore()
    jaws.context.restore()


  update: ->
    @x = @body.GetPosition().x
    @y = @body.GetPosition().y
