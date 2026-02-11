require 'gosu'

class BoostPickup
  attr_reader :x, :y, :active

  def initialize(x, y)
    @x = x
    @y = y

    @active = true
    @respawn_timer = 0.0

    @image = Gosu::Image.new("assets/ect/boost.png")  # should be 32×32
  end

  def update(dt)
    return if @active

    @respawn_timer -= dt
    @active = true if @respawn_timer <= 0
  end

  def draw
    return unless @active

    # Centered draw for 32×32 image
    @image.draw(@x - 16, @y - 16, 50)
  end

  def collect
    @active = false
    @respawn_timer = 3.0
  end
end