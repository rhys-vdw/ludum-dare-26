jaws.assets.add [ 'sprites/tank.png', 'sprites/wheel-8.png', 'sprites/wheel-12.png']

TERRAIN_PREDRAW_THRESH = 500
Game.SCALE = 20

$ ->
  Game.width = $(document).width()
  $('#game').attr width: Game.width, height: $(document).height()
  jaws.start Game.state, fps: 60


class Game.Camera
  constructor: ->
    @x = 100
    @y = 100

  update: ->
    # Move around the tank for now.
    @x = Game.tank.x + 500
    @y = Game.tank.y

Game.deltaTime = ->
  jaws.game_loop.tick_duration / 1000

Game.state = ->
  setup: ->
    gravity = new b2Vec2 0, 18
    Game.world = new b2World gravity, true

    # Create Terrain
    @terrain = new Game.Terrain(50)

    Game.tank = new Game.Tank 120, 10

    #setup debug draw
    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite jaws.context
    debugDraw.SetDrawScale Game.SCALE
    debugDraw.SetFillAlpha 0.3
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    Game.world.SetDebugDraw debugDraw
    Game.camera = new Game.Camera

    # Setup viewport
    @viewport = new jaws.Viewport({max_x: Infinity, max_y: 480})

  update: ->
    Game.world.Step Game.deltaTime()*0.5, 10, 10
    Game.world.ClearForces()
    Game.tank.update()
    Game.camera.update()
    @viewport.centerAround Game.camera
    if @viewport.x+@viewport.width+TERRAIN_PREDRAW_THRESH > @terrain.x*Game.SCALE
      @terrain.extendBy(50)

  draw: ->
    jaws.clear()
    @viewport.apply ->
      Game.world.DrawDebugData()
      Game.tank.draw()


