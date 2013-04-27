window.Game = {}

# Shit to run first 
# Box2D aliases
window.b2Vec2 = Box2D.Common.Math.b2Vec2
window.b2BodyDef = Box2D.Dynamics.b2BodyDef
window.b2Body = Box2D.Dynamics.b2Body
window.b2FixtureDef = Box2D.Dynamics.b2FixtureDef
window.b2Fixture = Box2D.Dynamics.b2Fixture
window.b2World = Box2D.Dynamics.b2World
window.b2MassData = Box2D.Collision.Shapes.b2MassData
window.b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
window.b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw

# http:#paulirish.com/2011/requestanimationframe-for-smart-animating/
window.requestAnimFrame =
  do ->
    return window.requestAnimationFrame       ||
           window.webkitRequestAnimationFrame ||
           window.mozRequestAnimationFrame    ||
           window.oRequestAnimationFrame      ||
           window.msRequestAnimationFrame     ||
           (callback, element) ->
             window.setTimeout callback, 1000 / 60
