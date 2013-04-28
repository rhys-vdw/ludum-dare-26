jaws.assets.add [ 'sprites/tank.png', 'sprites/wheel-8.png', 'sprites/wheel-12.png']

TERRAIN_PREDRAW_THRESH = 500
Game.SCALE = 20

$ ->
  Game.width = $(document).width()
  $('#game').attr width: Game.width, height: $(document).height()
  jaws.start Game.state, fps: 60

  Game.entities = new jaws.SpriteList()

  console.dir Game.entities


class Game.Camera
  constructor: ->
    # Setup viewport
    @viewport = new jaws.Viewport({max_x: Infinity, max_y: Infinity})
    @parallax = new jaws.Parallax({repeat_x: true})
    @parallax.addLayer({image: "sprites/hills-1.png", damping: 4, scale: 4})
    @xOffset = 5

  update: ->
    # Move around the upcoming terrian on y
    stepsIn = @viewport.x / Game.SCALE / jaws.game_state.terrain.stepWidth

    targetY = jaws.game_state.terrain.points[ Math.round(stepsIn)+15 ]
    # y = @moveTowards(@viewport.y - @viewport.height / 2, targetY)

    focalPoint = new b2Vec2(Game.tank.x + @xOffset, Game.tank.y)

    @centerAroundWorldPosition focalPoint
    @parallax.camera_x = @viewport.x
    @parallax.camera_y = @viewport.y

  centerAroundWorldPosition: (position) ->
    screenPosition = position.Copy()
    screenPosition.Multiply Game.SCALE
    @viewport.centerAround screenPosition

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

    applyToFixtures = (c, eventName) ->
      a = c.GetFixtureA().GetBody().GetUserData()
      b = c.GetFixtureB().GetBody().GetUserData()
      a?.entity?[eventName]?(b)
      b?.entity?[eventName]?(a)

    contactListener = {
      BeginContact: (c) ->
        applyToFixtures c, "onContactBegin"

      EndContact: (c) ->
        applyToFixtures c, "onContactEnd"

      PostSolve: (c) ->
        applyToFixtures c, "onContactPostSolve"

      PreSolve: (c) ->
        applyToFixtures c, "onContactPreSolve"
    }

    Game.world.SetContactListener contactListener

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

    Game.entities.deleteIf (e) ->
      isDead = e.isDead? && e.isDead() == true
      if isDead && e.onDestroy?
        e.onDestroy()
      return isDead

    Game.entities.updateIf (e) -> e.update?

    @hud.update()
    @camera.update()
    if @camera.viewport.x+@camera.viewport.width+TERRAIN_PREDRAW_THRESH > @terrain.x*Game.SCALE
      @terrain.extend()

  draw: ->
    jaws.clear()

    # Drawn relative to viewport
    @camera.apply =>
      Game.entities.draw()
      @terrain.draw()
      # Game.world.DrawDebugData()

    # Drawn relative to context
    @hud.draw(@camera)
