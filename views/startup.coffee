window.Game = {}

RAD_TO_DEG = 180 / Math.PI

# Shit to run first 
# Box2D aliases
window.b2Vec2 = Box2D.Common.Math.b2Vec2
window.b2Mat33 = Box2D.Common.Math.b2Mat33
window.b2BodyDef = Box2D.Dynamics.b2BodyDef
window.b2Body = Box2D.Dynamics.b2Body
window.b2FixtureDef = Box2D.Dynamics.b2FixtureDef
window.b2Fixture = Box2D.Dynamics.b2Fixture
window.b2World = Box2D.Dynamics.b2World
window.b2MassData = Box2D.Collision.Shapes.b2MassData
window.b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
window.b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw
window.b2PrismaticJoint = Box2D.Dynamics.Joints.b2PrismaticJoint
window.b2PrismaticJointDef = Box2D.Dynamics.Joints.b2PrismaticJointDef
window.b2RevoluteJoint = Box2D.Dynamics.Joints.b2RevoluteJoint
window.b2RevoluteJointDef = Box2D.Dynamics.Joints.b2RevoluteJointDef
window.b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef
