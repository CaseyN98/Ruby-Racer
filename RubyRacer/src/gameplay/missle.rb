# missle.rb
class Missile
  attr_reader :x, :y, :owner, :dead

  def initialize(x, y, angle, owner)
    @x, @y, @angle = x, y, angle
    @owner = owner
    @speed = 600.0
    @dead = false
    @lifetime = 3.0
    @image = Gosu::Image.new("assets/ect/missile.png")
  end

  def update(dt, players)
    # Move forward
    @x += Math.cos(@angle) * @speed * dt
    @y += Math.sin(@angle) * @speed * dt

    # Lifetime countdown
    @lifetime -= dt
    @dead = true if @lifetime <= 0

    # Collision with players
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
    # Adjusted rotation to match the car's orientation (assuming 0 is Right)
    @image.draw_rot(@x, @y, 60, Gosu.radians_to_degrees(@angle + Math::PI/2))
  end
end