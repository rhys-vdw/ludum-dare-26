class Game.Tank
  width = 5
  height = 0.2
  clearance = -0.2
  wheelCount = 5
  wheelRadius = 0.4

  createTank: (x, y) ->
    # Tank body.
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position.x = x
    bodyDef.position.y = y
    bodyDef.mass = 200

    # Create box for a shell.
    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.friction = 0.2
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
      fixtureDef.friction = 100

      wheel = Game.world.CreateBody bodyDef
      wheel.CreateFixture fixtureDef

      motorDef = new b2RevoluteJointDef
      motorDef.Initialize @body, wheel, wheelPos
      motorDef.enableMotor = true
      motorDef.motorSpeed = 20
      motorDef.maxMotorTorque = 50

      motor = Game.world.CreateJoint motorDef

      console.log motorDef, motor

      @wheels.push wheel
      @motors.push motor

  Rad2Deg = 180 / Math.PI

  constructor: (x, y) ->
    @bulletSpeed = 300
    @gunOffset = new b2Vec2 2, -2
    @x = x
    @y = y
    @createTank(x, y)
    @sprite = new jaws.Sprite {image: "sprites/tank.png", x: 0, y: -30, scale: 2.5, anchor: "center"}
    @wheelSprites = []
    for wheel in @wheels
      pos = wheel.GetPosition()
      wheel.sprite = new jaws.Sprite( { image: "sprites/wheel-8.png", x: 0, y: 0, anchor:"center", scale: 3 } )

    jaws.on_keydown 'space', @fire
    Game.entities.push @

  gunPosition: ->
    theta = @body.GetAngle()
    x = 3
    y = -2.5
    cost = Math.cos theta
    sint = Math.sin theta

    return new b2Vec2 x * cost - y * sint, x * sint + y * cost

  forwardVector: ->
    rads = @body.GetAngle()
    return new b2Vec2 Math.cos(rads), Math.sin(rads)


  fire: =>
    console.log "Fire!"
    
    debugger
    # TODO: Remove scaling
    pos = new b2Vec2 @x, @y
    pos.Add @gunPosition()

    #debugger;

    force = @forwardVector();
    force.Multiply 30000

    new Game.Bullet pos, force

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

    gunPos = @gunPosition()
    gunPos.Multiply Game.SCALE
    # console.log gunPos
    forward = @forwardVector()
    forward.Multiply @bulletSpeed

    line = gunPos.Copy()
    line.Add forward


    # Draw that red line for showing gun pos.
    # Unrotate first...
    jaws.context.restore()

    jaws.context.beginPath()
    jaws.context.moveTo gunPos.x, gunPos.y
    jaws.context.lineTo line.x, line.y
    jaws.context.strokeStyle = '#FF0000'
    jaws.context.stroke()

    jaws.context.restore()


  update: ->
    @x = @body.GetPosition().x
    @y = @body.GetPosition().y
