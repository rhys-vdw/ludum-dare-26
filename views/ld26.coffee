jaws.assets.add [ 'sprites/tank.png', 'sprites/wheel-8.png', 'sprites/wheel-12.png']

TERRAIN_PREDRAW_THRESH = 500
Game.SCALE = 20

$ ->
  Game.width = $(document).width()
  $('#game').attr width: Game.width, height: $(document).height()
  jaws.start Game.state, fps: 60


class Game.Camera
  constructor: ->
    # Setup viewport
    @viewport = new jaws.Viewport({max_x: Infinity, max_y: Infinity})
    @x = 100
    @y = 100
    @parallax = new jaws.Parallax({repeat_x: true})
    @parallax.addLayer({image: "sprites/hills-1.png", damping: 4, scale: 4})

  update: ->
    # Move around the tank on x
    @x = Game.tank.x + 500
    #@y = Game.tank.y

    # Move around the upcoming terrian on y
    stepsIn = @x/(jaws.game_state.terrain.stepWidth*Game.SCALE)
    @targetY = jaws.game_state.terrain.points[ Math.round(stepsIn)+15 ]*Game.SCALE
    @y = @moveTowards(@y, @targetY)

    @parallax.camera_x = @viewport.x
    @parallax.camera_y = @viewport.y
    @viewport.centerAround this

  apply: (func) =>
    @parallax.draw()
    @viewport.apply func

  moveTowards: (current, target) ->
    return current + (target - current)/ 20

Game.deltaTime = ->
  jaws.game_loop.tick_duration / 1000

Game.state = ->
  setup: ->
    gravity = new b2Vec2 0, 18
    Game.world = new b2World gravity, true

    # Create Terrain
    @terrain = new Game.Terrain()

    Game.tank = new Game.Tank 10, 30

    #setup debug draw
    debugDraw = new b2DebugDraw()
    debugDraw.SetSprite jaws.context
    debugDraw.SetDrawScale Game.SCALE
    debugDraw.SetFillAlpha 0.3
    debugDraw.SetLineThickness 1.0
    debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
    Game.world.SetDebugDraw debugDraw
    @hud = new Game.Hud

    @camera = new Game.Camera

  update: ->
    Game.world.Step Game.deltaTime()*0.5, 10, 10
    Game.world.ClearForces()
    Game.tank.update()
    Game.Bullet.all.update()
    @hud.update()
    @camera.update()
    if @camera.viewport.x+@camera.viewport.width+TERRAIN_PREDRAW_THRESH > @terrain.x*Game.SCALE
      @terrain.extend()

  draw: ->
    jaws.clear()

    # Drawn relative to viewport
    @camera.apply =>
      Game.tank.draw()
      Game.Bullet.all.draw()
      @terrain.draw()
      # Game.world.DrawDebugData()

    # Drawn relative to context
    @hud.draw(@camera)
