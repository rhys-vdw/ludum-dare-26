class Game.Gun
  constructor: (options) ->
    # Attached body
    @attachment = options.attachment
    # Force
    @force = options.force
    # Can fire immediately
    @fireDelay = options.fireDelay
    @nextFireDelay = 0

    Game.entities.push @

  fire: ->
    return unless @nextFireDelay <= 0
    force = @forwardVector()
    force.Multiply 300000
    pos = new b2Vec2 @attachment.GetPosition().x, @attachment.GetPosition().y
    pos.Add @position()
    new Game.Bullet pos, force
    @nextFireDelay = @fireDelay

  position: ->
    theta = @attachment.GetAngle()
    x = 3
    y = -1.5
    cost = Math.cos theta
    sint = Math.sin theta
    return new b2Vec2 x * cost - y * sint, x * sint + y * cost

  forwardVector: ->
    rads = @attachment.GetAngle()
    return new b2Vec2 Math.cos(rads), Math.sin(rads)

  update: ->
    @nextFireDelay -= Game.deltaTime()
    @fire() if jaws.pressed 'space'

  draw: ->
