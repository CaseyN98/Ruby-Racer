require 'chingu'
require_relative '../core/config'
require_relative '../gameplay/car_select'
require_relative '../gameplay/track_select'
require_relative '../core/game'
require_relative 'player_mode_menu'
require_relative '../gameplay/open_world'   # <-- NEW

class Menu < Chingu::GameState
  def initialize
    super

    @options = [
      "PLAYER MODE",
      "CAR SELECT",
      "START RACE",
      "OPEN WORLD",   # <-- NEW OPTION
      "QUIT"
    ]

    @selected = 0
    @input_timer = 300

    @title_font = Gosu::Font.new(64)
    @font       = Gosu::Font.new(32)

    # Visual assets
    @bg   = Gosu::Image.new("assets/ect/menu_bg.png", tileable: true)
    @logo = Gosu::Image.new("assets/ect/logo.png")
  end

  def update
    super
    @input_timer -= $window.dt if @input_timer > 0
    return if @input_timer > 0

    if Input.up
      @selected = (@selected - 1) % @options.length
      @input_timer = 200

    elsif Input.down
      @selected = (@selected + 1) % @options.length
      @input_timer = 200

    elsif Input.confirm
      handle_select
      @input_timer = 300
    end
  end

  def handle_select
    case @selected
    when 0 then push_game_state(PlayerModeMenu)      # PLAYER MODE
    when 1 then push_game_state(CarSelect.new(0))    # CAR SELECT
    when 2 then push_game_state(TrackSelect)         # START RACE
    when 3 then push_game_state(OpenWorld)           # OPEN WORLD
    when 4 then $window.close                        # QUIT
    end
  end

  def draw
    return unless $window
    super

    w = $window.width
    h = $window.height

    # -----------------------------------
    # BACKGROUND IMAGE
    # -----------------------------------
    @bg.draw(0, 0, 0, w.to_f / @bg.width, h.to_f / @bg.height)

    # -----------------------------------
    # LOGO (centered)
    # -----------------------------------
    logo_x = (w - @logo.width) / 2
    @logo.draw(logo_x, 10, 10)

    # -----------------------------------
    # MENU OPTIONS
    # -----------------------------------
    base_y = 280

    @options.each_with_index do |opt, i|
      text_w = @font.text_width(opt)
      x = (w - text_w) / 2
      y = base_y + i * 70

      selected = (i == @selected)

      # Highlight bar behind selected option
      if selected
        Gosu.draw_rect(
          x - 30, y - 10,
          text_w + 60, 60,
          Gosu::Color.rgba(255, 255, 255, 40),
          5
        )
      end

      # Slight scale animation for selected option
      scale = selected ? 1.05 + Math.sin(Gosu.milliseconds / 200.0) * 0.03 : 1.0
      color = selected ? Gosu::Color::YELLOW : Gosu::Color::WHITE

      @font.draw_text(opt, x, y, 10, scale, scale, color)
    end
  end
end