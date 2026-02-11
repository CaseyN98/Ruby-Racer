# src/core/camera.rb
class Camera
  attr_accessor :target, :x, :y, :scale

  def initialize(target)
    @target = target
    @x = target&.x || 0
    @y = target&.y || 0
    @scale = 1.2
  end

  def update(dt)
    return unless @target
    @x += (@target.x - @x) * 5 * dt
    @y += (@target.y - @y) * 5 * dt
  end

  # Supports:
  #   attach(window)
  #   attach(window, split: true)
  #   attach(window, split: true, offset_x: 640)
  def attach(window, split: false, offset_x: 0)
    viewport_width = split ? window.width / 2 : window.width

    Gosu.scale(@scale, @scale) do
      cx = (viewport_width / (2.0 * @scale)) + (offset_x / @scale)
      cy = window.height / (2.0 * @scale)

      Gosu.translate(cx - @x, cy - @y) do
        yield
      end
    end
  end
end