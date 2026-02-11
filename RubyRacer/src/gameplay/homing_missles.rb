# homing_missile.rb
class HomingMissile
  attr_reader :x, :y, :owner, :dead

  def initialize(x, y, angle, owner, players)
    @x, @y, @angle = x, y, angle
    @owner = owner
    @speed = 500.0
    @turn_rate = 3.0          # radians per second
    @dead = false
    @lifetime = 4.0
    @image = Gosu::Image.new("assets/ect/missile.png")

    # Pick closest enemy at spawn
    @target = players.reject { |p| p == owner }.min_by do |p|
      Gosu.distance(@x, @y, p.x, p.y)
    end
  end

  def update(dt, players)
    return if @dead

    # If target died or vanished, try reacquiring
    if @target.nil? || @target.dead?
      @target = players.reject { |p| p == @owner }.min_by do |p|
        Gosu.distance(@x, @y, p.x, p.y)
      end
    end

    # Rotate toward target
    if @target
      desired_angle = Math.atan2(@target.y - @y, @target.x - @x)
      angle_diff = normalize_angle(desired_angle - @angle)

      # Clamp rotation speed
      @angle += angle_diff.clamp(-@turn_rate * dt, @turn_rate * dt)
    end

    # Move forward
    @x += Math.cos(@angle) * @speed * dt
    @y += Math.sin(@angle) * @speed * dt

    # Lifetime
    @lifetime -= dt
    @dead = true if @lifetime <= 0

    # Collision
    players.each do |player|
      next if player == @owner
      next if @dead

      if Gosu.distance(@x, @y, player.x, player.y) < 30
        player.hit_by_missile
        @dead = true
      end
    end
  end

  def draw
    @image.draw_rot(@x, @y, 60, Gosu.radians_to_degrees(@angle + Math::PI/2))
  end

  private

  def normalize_angle(a)
    a = a % (Math::PI * 2)
    a -= Math::PI * 2 if a > Math::PI
    a += Math::PI * 2 if a < -Math::PI
    a
  end
end