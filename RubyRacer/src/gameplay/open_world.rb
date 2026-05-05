# gameplay/open_world.rb
require 'chingu'
require 'gosu'
require_relative '../core/world_manager'
require_relative '../core/config'
require_relative '../gameplay/car'
require_relative '../core/input'

class OpenWorld < Chingu::GameState
  def initialize
    super

    layout = [
      ["city1", "city2"]
    ]

    @world = WorldManager.new(layout, chunk_size: 2048)

    @player = Car.new(Config::CARS[0], ai: false, player_index: 0)
    @player.x = 1680
    @player.y = 1980

    @cam_x = 0.0
    @cam_y = 0.0
  end

def update
  super
  dt = $window.dt / 1000.0

  @world.update(@player.x, @player.y)

  @player.update(
    dt: dt,
    input: Input,
    map: @world,
    waypoints: [],
    all_players: [@player]
  )

  update_camera
end

  def update_camera
    w = $window.width
    h = $window.height

    @cam_x = @player.x - w / 2.0
    @cam_y = @player.y - h / 2.0

    @cam_x = @cam_x.clamp(0, @world.width - w)
    @cam_y = @cam_y.clamp(0, @world.height - h)
  end

  def draw
    return unless $window
    super

    w = $window.width
    h = $window.height

    @world.draw(@cam_x, @cam_y, w, h)

    Gosu.translate(-@cam_x, -@cam_y) do
      @player.draw
    end
  end
end