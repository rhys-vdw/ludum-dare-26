class Game.Wheel
  # Private static functions.
  createWheelBody = (options, tank) ->
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position = options.position
    bodyDef.mass = 10
    bodyDef.userData = type: "wheel", entity: tank

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.restitution = 0
    fixtureDef.friction = 100
    fixtureDef.shape = new b2CircleShape options.radius

    body = Game.world.CreateBody bodyDef
    body.CreateFixture fixtureDef
    return body

  createSuspension = (options, axleBody) ->
    springDef = new b2PrismaticJointDef
    springDef.lowerTranslation = -options.travel
    springDef.upperTranslation = 0
    springDef.enableLimit = true
    springDef.enableMotor = true
    springDef.maxMotorForce = options.suspensionForce
    springDef.motorSpeed = options.suspensionSpeed
    springDef.Initialize options.parentBody, axleBody, options.position, new b2Vec2(0,1)
    return Game.world.CreateJoint springDef

  createAxleBody = (options, wheelBody) ->
    # Create axel.
    bodyDef = new b2BodyDef
    bodyDef.type = b2Body.b2_dynamicBody
    bodyDef.position = options.position
    bodyDef.mass = 1

    fixtureDef = new b2FixtureDef
    fixtureDef.density = 1.0
    fixtureDef.restitution = 0
    fixtureDef.friction = 100
    fixtureDef.restitution = 0.5
    fixtureDef.shape = new b2PolygonShape
    fixtureDef.shape.SetAsBox options.radius / 2, options.radius / 2

    body = Game.world.CreateBody bodyDef
    body.CreateFixture fixtureDef
    return body

  createMotor = (options, axleBody, wheelBody) ->
    # Create wheel to axel motor joint.
    motorDef = new b2RevoluteJointDef
    motorDef.Initialize axleBody, wheelBody, options.position
    motorDef.enableMotor = true
    motorDef.motorSpeed = options.speed
    motorDef.maxMotorTorque = options.torque
    return Game.world.CreateJoint motorDef

  constructor: (options) ->
    # Default options
    options = $.extend {
        position: b2Vec2(0, 0)
        radius: 0.4
        torque: 50
        speed: 20
        image: 'No image specified'
        parentBody: null
        spriteOffset: new b2Vec2(0, 0)
        spriteScale: 1
        travel: 0.3
        suspensionSpeed: 4
        suspensionForce: 8
    }, options

    @radius = options.radius
    @torqe = options.torque
    @speed = options.speed

    @wheelBody = createWheelBody options, @

    # If a parent body is supplied, create axle, suspension and rotating joint.
    if options.parentBody != null
      @axleBody = createAxleBody options, @wheelBody
      @suspension = createSuspension options, @axleBody
      @motor = createMotor options, @axleBody, @wheelBody

    @sprite = new jaws.Sprite
      image: options.image
      x: options.spriteOffset.x
      y: options.spriteOffset.y
      scale: options.spriteScale
      anchor: "center"

    @isGrounded = false

    Game.entities.push @

  draw: ->
    pos = @wheelBody.GetPosition()
    jaws.context.save()
    jaws.context.translate pos.x * Game.SCALE, pos.y * Game.SCALE
    jaws.context.rotate @wheelBody.GetAngle()
    @sprite.draw()
    jaws.context.restore()

  setMotor: (speed, torque) ->
    @motor.SetMotorSpeed speed
    @motor.SetMaxMotorTorque torque

  onContactBegin: (c) ->
    if c?.type? && c.type == "ground"
      @isGrounded = true

  onContactEnd: (c) ->
    if c?.type? && c.type == "ground"
      @isGrounded = false
