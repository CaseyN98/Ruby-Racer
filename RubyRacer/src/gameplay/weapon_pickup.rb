# weapon_pickup.rb
require 'gosu'

class WeaponPickup
  attr_reader :x, :y, :active

  def initialize(x, y)
    @x = x
    @y = y
    @active = true
    @respawn_timer = 0
    # Placeholder color for weapon box (Cyan/Light Blue)
    @image = Gosu::Image.new("assets/ect/weapon.png")
  end

  def update(dt)
    if !@active
      @respawn_timer -= dt
      @active = true if @respawn_timer <= 0
    end
  end

  def collect
    @active = false
    @respawn_timer = 10.0 # Respawns after 10 seconds
  end

  def draw
    return unless @active
    # Drawing a simple box for the pickup

    @image.draw(@x - 16, @y - 16, 50)
  end
end