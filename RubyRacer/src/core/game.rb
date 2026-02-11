require 'chingu'
require_relative 'config'
require_relative '../gameplay/car'
require_relative '../gameplay/map'
require_relative 'camera'
require_relative '../ui/ui'
require_relative 'input'
require_relative '../gameplay/missle'
require_relative '../gameplay/homing_missles'
require_relative '../gameplay/race_over'
require_relative '../gameplay/stats'
require_relative '../gameplay/boost_pickup'
require_relative '../gameplay/weapon_pickup'

class Game < Chingu::GameState
  attr_reader :players, :race_time, :countdown, :best_lap_times

  def initialize
    super
    @map     = Map.new(Config::TRACK[:map_id])
    @players = []

    Config.players.each_with_index do |pdata, i|
      @players << Car.new(Config::CARS[pdata[:car_index]], ai: false, player_index: i)
    end

    setup_positions

    @cameras  = @players.map { |car| Camera.new(car) }
    @missiles = []

    @countdown        = Config::RACE[:countdown].to_f
    @race_time        = 0.0
    @lap_start_times  = Array.new(@players.size, 0.0)
    @best_lap_times   = Array.new(@players.size)
  end

  def setup_positions
    start = Config::TRACKS[Config::TRACK[:map_id]][:start]

    @players.each_with_index do |car, i|
      car.angle = start[:angle]

      offset_direction = (start[:angle] == 0 ? 1 : -1)
      offset_angle = start[:angle] + (offset_direction * Math::PI / 2)

      car.x = start[:x] + (i * 40 * Math.cos(offset_angle))
      car.y = start[:y] + (i * 40 * Math.sin(offset_angle))
    end
  end

  def update
    return unless $window
    dt = $window.dt / 1000.0

    # Countdown before race starts
    if @countdown > 0
      @countdown -= dt
      return
    end

    @race_time += dt

    # Update pickups
    @map.boost_pickups.each  { |p| p.update(dt) }
    @map.weapon_pickups.each { |p| p.update(dt) }

    # Update players
    @players.each_with_index do |car, i|
      car.update(
        dt: dt,
        input: Input,
        map: @map,
        waypoints: [],
        player_index: i,
        all_players: @players
      )

      # Missile spawning logic
      case car.missile_to_spawn
      when :homing
        @missiles << HomingMissile.new(car.x, car.y, car.angle, car, @players)
        car.missile_to_spawn = false

      when true
        @missiles << Missile.new(car.x, car.y, car.angle, car)
        car.missile_to_spawn = false
      end

      # Car-to-car collision
      @players.each do |other|
        next if other == car
        car.collide_with(other)
      end

      @cameras[i].update(dt)
      check_triggers(car, i)
    end

    # Update missiles
    @missiles.each { |m| m.update(dt, @players) }
    @missiles.reject!(&:dead)

    super
  end

  def check_triggers(car, index)
    px, py = car.x, car.y

    # Boost pickups
    @map.boost_pickups.each do |pickup|
      if pickup.active && Gosu.distance(px, py, pickup.x, pickup.y) < 40
        pickup.collect
        car.has_boost = true
      end
    end

    # Weapon pickups
    @map.weapon_pickups.each do |pickup|
      if pickup.active && Gosu.distance(px, py, pickup.x, pickup.y) < 40
        pickup.collect
        car.weapon = [:missile, :homing_missile, :shield, :charged_shield].sample
      end
    end

    # Lap + checkpoint logic
    if @map.area_check(px, py, 5, :finish) && car.checkpoint_passed
      lap_time = @race_time - @lap_start_times[index]

      if @best_lap_times[index].nil? || lap_time < @best_lap_times[index]
        @best_lap_times[index] = lap_time
      end

      car.lap += 1
      car.checkpoint_passed   = false
      @lap_start_times[index] = @race_time

      if car.lap > Config::RACE[:total_laps]
        stats = {
          race_time: @race_time,
          best_lap_time: @best_lap_times[index],
          laps: car.lap - 1
        }
        push_game_state(RaceOver.new(stats))
      end

    elsif @map.area_check(px, py, 5, :checkpoint)
      car.checkpoint_passed = true
    end
  end

  def draw
    return unless $window

    if Config.player_mode == :two_player && @players.size >= 2
      w_half = $window.width / 2

      # Left screen
      $window.clip_to(0, 0, w_half, $window.height) do
        @cameras[0].attach($window, split: true) { draw_world }
      end

      # Right screen
      $window.clip_to(w_half, 0, w_half, $window.height) do
        @cameras[1].attach($window, split: true, offset_x: w_half) { draw_world }
      end

      Gosu.draw_rect(w_half - 2, 0, 4, $window.height, Gosu::Color::BLACK, 100)

      UI.draw_player_ui(self, @players[0], 0)
      UI.draw_player_ui(self, @players[1], w_half)

    else
      $window.clip_to(0, 0, $window.width, $window.height) do
        @cameras[0].attach($window) { draw_world }
      end

      UI.draw_player_ui(self, @players[0], 0)


    end
  end

  def draw_world
    @map.draw
    @map.boost_pickups.each(&:draw)
    @map.weapon_pickups.each(&:draw)
    @missiles.each(&:draw)
    @players.each(&:draw)

  end
end