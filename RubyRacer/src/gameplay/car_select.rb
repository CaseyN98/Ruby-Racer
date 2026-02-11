require_relative '../core/input'
require_relative '../ui/ui'
class CarSelect < Chingu::GameState
  def initialize(player_index = 0)
    super

    @player_index = player_index
    @cars = Config::CARS

    current_index = Config.players[@player_index][:car_index] || 0
    @index = current_index

    @title_font = Gosu::Font.new(48)
    @font       = Gosu::Font.new(28)
    @small      = Gosu::Font.new(22)

    @input_timer = 300
  end

  def update
    super
    @input_timer -= $window.dt if @input_timer > 0
    return if @input_timer > 0

    if Input.left
      @index = (@index - 1) % @cars.length
      @input_timer = 200

    elsif Input.right
      @index = (@index + 1) % @cars.length
      @input_timer = 200

    elsif Input.confirm
      Config.players[@player_index][:car_index] = @index

      # --- 1 PLAYER MODE ---
      if Config.player_mode == :one_player
        push_game_state(TrackSelect)
        return
      end

      # --- 2 PLAYER MODE ---
      if @player_index == 0
        # Go to Player 2 car select
        push_game_state(CarSelect.new(1))
      else
        # Both players selected → go to track select
        push_game_state(TrackSelect)
      end

      @input_timer = 300

    elsif Input.back
      switch_game_state(Menu)
      @input_timer = 300
    end
  end

  def draw
    return unless $window
    super

    w = $window.width
    h = $window.height

    # -----------------------------------
    # BACKGROUND GRADIENT
    # -----------------------------------
    Gosu.draw_quad(
      0,   0, Gosu::Color.rgb(25, 25, 45),
      w,   0, Gosu::Color.rgb(15, 15, 30),
      0,   h, Gosu::Color.rgb(5, 5, 20),
      w,   h, Gosu::Color.rgb(0, 0, 10),
      0
    )

    # -----------------------------------
    # TITLE WITH GLOW
    # -----------------------------------
    title = "PLAYER #{@player_index + 1} - SELECT YOUR CAR"
    tw = @title_font.text_width(title)
    tx = (w - tw) / 2
    ty = 60

    @title_font.draw_text(title, tx + 2, ty + 2, 9, 1, 1, Gosu::Color::BLACK)
    @title_font.draw_text(title, tx, ty, 10, 1, 1, Gosu::Color::YELLOW)

    # -----------------------------------
    # CAR NAME
    # -----------------------------------
    car = @cars[@index]
    name = car[:name]
    nw = @font.text_width(name)

    @font.draw_text(name, (w - nw) / 2, 150, 10, 1, 1, Gosu::Color::WHITE)

    # -----------------------------------
    # CAR IMAGE WITH FRAME
    # -----------------------------------
    img = Gosu::Image.new(car[:sprite])
    scale = 2.0
    img_x = (w - img.width * scale) / 2
    img_y = 210

    # Frame behind car
    Gosu.draw_rect(img_x - 20, img_y - 20,
                   img.width * scale + 40,
                   img.height * scale + 40,
                   Gosu::Color.rgba(255, 255, 255, 20), 5)

    img.draw(img_x, img_y, 10, scale, scale)

    # -----------------------------------
    # LEFT/RIGHT ARROWS (animated)
    # -----------------------------------
    pulse = 150 + Math.sin(Gosu.milliseconds / 200.0) * 105
    arrow_color = Gosu::Color.rgba(255, 255, 0, pulse.to_i)

    @font.draw_text("◄", img_x - 60, img_y + 40, 10, 1.2, 1.2, arrow_color)
    @font.draw_text("►", img_x + img.width * scale + 20, img_y + 40, 10, 1.2, 1.2, arrow_color)

    # -----------------------------------
    # STATS PANEL
    # -----------------------------------
    panel_y = 350
    panel_h = 160

    Gosu.draw_rect(
      w/2 - 200, panel_y - 20,
      400, panel_h,
      Gosu::Color.rgba(255, 255, 255, 20),
      5
    )

    draw_stat("Max Speed", car[:max_speed], 350)
    draw_stat("Acceleration", car[:accel], 390)
    draw_stat("Turn Rate", car[:turn], 430)
    draw_stat("Brake Power", car[:brake], 470)

    # -----------------------------------
    # FOOTER HINTS (animated fade)
    # -----------------------------------
    alpha = 180 + Math.sin(Gosu.milliseconds / 300.0) * 40
    hint_color = Gosu::Color.rgba(200, 200, 200, alpha.to_i)

    @small.draw_text("← →  Choose Car", w/2 - 400, h - 120, 10, 1, 1, hint_color)
    @small.draw_text("ENTER to Confirm", w/2 - 400, h - 80, 10, 1, 1, hint_color)
    @small.draw_text("ESC to Go Back",   w/2 - 400, h - 40, 10, 1, 1, hint_color)
  end

  def draw_stat(label, value, y)
    w = $window.width
    text = "#{label}: #{value}"
    tw = @small.text_width(text)
    @small.draw_text(text, (w - tw) / 2, y, 10, 1, 1, Gosu::Color::GRAY)
  end
end