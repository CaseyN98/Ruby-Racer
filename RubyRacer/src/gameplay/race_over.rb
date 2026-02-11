# race_over.rb
require 'chingu'
require_relative '../core/input'
require_relative '../ui/menu'

class RaceOver < Chingu::GameState
  def initialize(stats)
    super()
    @stats = stats
    @font = Gosu::Font.new(32)
    @small = Gosu::Font.new(24)
    @input_timer = 500   # prevent instant skipping
  end

  def update
    @input_timer -= $window.dt if @input_timer > 0
    return if @input_timer > 0
    super
    # Press confirm to return to menu
    if Input.confirm
      switch_game_state(Menu)
    end
  end

  def draw
    return unless $window
    super

    w = $window.width
    h = $window.height

    @font.draw_text("RACE COMPLETE", w/2 - 150, h/2 - 150, 10, 1, 1, Gosu::Color::YELLOW)

    @small.draw_text("Total Time: #{@stats[:race_time].round(2)}s",
                     w/2 - 120, h/2 - 50, 10)
    @small.draw_text("Best Lap: #{@stats[:best_lap_time].round(2)}s",
                     w/2 - 120, h/2, 10)
    @small.draw_text("Laps: #{@stats[:laps]}",
                     w/2 - 120, h/2 + 50, 10)

    @small.draw_text("Press ENTER to continue",
                     w/2 - 150, h/2 + 120, 10, 1, 1, Gosu::Color::GRAY)
  end
end