class Game.Gun
  constructor: (options) ->
    @force = options.force
    @attachment = options.attachment

  fire: ->
    force = @forwardVector()
    force.Multiply 300000
    pos = new b2Vec2 @attachment.GetPosition().x, @attachment.GetPosition().y
    pos.Add @position()
    new Game.Bullet pos, force

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
