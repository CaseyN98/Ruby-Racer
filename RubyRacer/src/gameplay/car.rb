# car.rb
require_relative '../core/input'
require_relative '../core/audio'

class Car
  attr_accessor :x, :y, :missile_to_spawn, :angle, :speed, :lap, :checkpoint_passed,
                :boost_timer, :vx, :vy, :has_boost, :weapon, :shield_timer,
                :charged_shield, :stun_timer

  attr_reader :stats

  def initialize(cfg, ai: false, player_index: nil)
    @image = Gosu::Image.new(cfg[:sprite])
    @flame_image  = Gosu::Image.new("assets/ect/flame.png")
    @shield_image = Gosu::Image.new("assets/ect/shield.png")
    @stats = cfg
    @is_ai = ai
    @player_index = player_index
    @rev_cooldown = 0.0

    reset
  end

  def radius
    20
  end

  def reset
    @speed = 0.0
    @angle = 0.0
    @vx = 0.0
    @vy = 0.0
    @lap = 1
    @checkpoint_passed = false
    @boost_timer = 0.0
    @has_boost = false
    @weapon = nil
    @shield_timer = 0.0
    @charged_shield = false
    @stun_timer = 0.0
    @steer = 0.0
    @throttle = 0.0
    @brake = 0.0
    @missile_to_spawn = false
  end

  def update(dt:, input: nil, map:, waypoints:, player_index: nil, all_players: [])
    idx = player_index || @player_index || 0

    if @stun_timer > 0
      @stun_timer -= dt
      @speed = 0.0
      @vx = 0.0
      @vy = 0.0
      return
    end

    if @is_ai
      update_ai(dt, waypoints)
    else
      @throttle = input.throttle(idx) - input.reverse(idx)
      return if dt.nil? || dt <= 0

      if input.use_weapon(idx) && @weapon
        activate_weapon(all_players)
        @weapon = nil
      end

      if input.use_boost(idx) && @has_boost && @boost_timer <= 0
        @boost_timer = 1.5
        @boost_channel = Audio.boost
        @has_boost = false
      end

      @steer = input.steer(idx)
      @brake = input.brake(idx)
    end

    if @shield_timer > 0
      @shield_timer -= dt
      @charged_shield = false if @shield_timer <= 0
    end

    if @charged_shield
      all_players.each do |other|
        next if other == self
        next if other.shield_timer > 0
        next if other.charged_shield

        if Gosu.distance(@x, @y, other.x, other.y) < 150
          other.stun_timer = 0.2
          other.speed = 0.0
        end
      end
    end

    cur_accel = @stats[:accel]
    cur_max   = @stats[:max_speed]
    drag      = 0.98

    if @boost_timer > 0
      @boost_timer -= dt
      cur_accel *= 2.5
      cur_max   *= 1.5
    end

    unless map.check_type(@x, @y, :road)
      cur_max *= 0.35
      drag = 0.88
    end

    @speed += @throttle * cur_accel * dt
    @speed -= @brake * @stats[:brake] * dt if @brake > 0
    @speed *= (drag ** (dt * 60))
    @speed = @speed.clamp(-120, cur_max)

    turn_ability = (@speed.abs / 220.0).clamp(0.25, 1.2)
    @angle += @steer * @stats[:turn] * turn_ability * dt

    @vx = Math.cos(@angle) * @speed
    @vy = Math.sin(@angle) * @speed

    dx = @vx * dt
    dy = @vy * dt

    if map.is_road_world?(@x + dx, @y + dy)
      @x += dx
      @y += dy
    else
      @speed *= -0.5
    end
  end

  def activate_weapon(all_players)
    case @weapon
    when :missile
      @missile_to_spawn = true
    when :homing_missile
      @missile_to_spawn = :homing
    when :shield
      @shield_timer = 5.0
    when :charged_shield
      @shield_timer = 3.0
      @charged_shield = true
    end
  end
  def hit_by_missile
    return if @shield_timer > 0 || @charged_shield
    @stun_timer = 3.0
    @speed = 0.0
    @boost_timer = 0
  end

  def collide_with(other)
    dist = Gosu.distance(@x, @y, other.x, other.y)
    if dist < radius * 2
      overlap = (radius * 2) - dist
      angle = Gosu.angle(@x, @y, other.x, other.y)

      move_x = Gosu.offset_x(angle, overlap / 2.0)
      move_y = Gosu.offset_y(angle, overlap / 2.0)

      @x -= move_x
      @y -= move_y
      other.x += move_x
      other.y += move_y

      @speed *= 0.8
      other.speed *= 0.8
    end
  end

  def draw
    if @boost_timer > 0
      flame_x = @x - Math.cos(@angle) * 25
      flame_y = @y - Math.sin(@angle) * 25
      @flame_image.draw_rot(flame_x, flame_y, 0, Gosu.radians_to_degrees(@angle))
    end

    if @shield_timer > 0
      # Use same shield asset with different colors
      color = @charged_shield ? Gosu::Color::YELLOW : Gosu::Color.rgba(0, 255, 255, 180)
      @shield_image.draw_rot(@x, @y, 2, 0, 0.5, 0.5, 1.0, 1.0, color)
    end

    if @stun_timer > 0
      # Highlight stunned state with a red glow or simple rect if no asset available
      Gosu.draw_rect(@x - 20, @y - 20, 40, 40, Gosu::Color.rgba(255, 0, 0, 100), 5)
    end

    @image.draw_rot(@x, @y, 1, Gosu.radians_to_degrees(@angle + Math::PI / 2))
  end

  def accelerating?
    @throttle > 0
  end
end