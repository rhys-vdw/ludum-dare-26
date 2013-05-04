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
    @acceleration = 0
    @currentBoostPower = 0

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
    @gun = new Game.Gun { force: 50, attachment: @body, fireDelay: 0.1 }

    # Now lets add some wheels.
    wheelSpacing = width / (wheelCount - 1)
    @wheels = []
    for i in [0...wheelCount]
      lift = if i == 0 or i == wheelCount-1 then -0.2 else 0
      pos = new b2Vec2 x - width / 2 + wheelSpacing * i, y + height / 2 + clearance + lift
      @wheels.push new Game.Wheel
        position: pos, 
        wheelRadius: wheelRadius,
        torque: baseMotorTorque,
        speed: baseMotorSpeed,
        image: "sprites/wheel-8.png",
        parentBody: @body,
        spriteScale: 3,
        travel: 0.3

  Rad2Deg = 180 / Math.PI

  constructor: (x, y) ->
    @groundedWheelCount = 0
    @gunOffset = new b2Vec2 2, -2
    @x = x
    @y = y
    @createTank(x, y)
    @sprite = new jaws.Sprite {image: "sprites/tank.png", x: 0, y: -10, scale: 2.5, anchor: "center"}


    jaws.on_keydown 'period', @jump
    jaws.on_keydown 'z', @boostStart
    jaws.on_keyup   'z', @boostEnd
    Game.entities.push @


  boostStart: =>
    console.log 'boost start'
    @acceleration = 1

  boostEnd: =>
    console.log 'boost end'
    @acceleration = -1

  setMotorSpeed: (speed, torque) ->
    for wheel in @wheels
      wheel.setMotor speed, torque

  jump: =>
    if @isGrounded
      v = @body.GetLinearVelocity()
      v.Add new b2Vec2 0, -100
      @body.SetLinearVelocity v

  draw: ->
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

  onContactBegin: (c) ->
    if c?.type? && c.type == "ground"
      @sprite.scale = 1
      @isChassyGrounded = true

  onContactEnd: (c) ->
    if c?.type? && c.type == "ground"
      @sprite.scale = 3
      @isChassyGrounded = false

  update: ->
    # Update positioon
    @x = @body.GetPosition().x
    @y = @body.GetPosition().y
    # Update groundedness
    @isGrounded = @isChassyGrounded || _.some @wheels, (wheel) ->
      wheel.isGrounded

    # Update motor speed
    @currentBoostPower += @acceleration/10
    @currentBoostPower = Math.min(1, @currentBoostPower)
    @currentBoostPower = Math.max(0, @currentBoostPower)
    speed = baseMotorSpeed + (boostMotorSpeed - baseMotorSpeed) * @currentBoostPower
    torque = baseMotorTorque + (boostMotorTorque - baseMotorTorque) * @currentBoostPower
    @setMotorSpeed speed, torque
