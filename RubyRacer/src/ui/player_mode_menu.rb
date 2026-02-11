class PlayerModeMenu < Chingu::GameState
  def initialize
    super
    @options = ["1 PLAYER", "2 PLAYERS", "BACK"]
    @selected = 0
    @input_timer = 300
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
    when 0
      Config.player_mode = :one_player
      Config.players = [Config::DEFAULT_PLAYERS[0].dup]   # FIXED
      pop_game_state
      $window.input.clear

    when 1
      # 2 PLAYER MODE
      Config.player_mode = :two_player
      Config.players = Config::DEFAULT_PLAYERS.map(&:dup)
      pop_game_state

    when 2
      pop_game_state
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
      0,   0, Gosu::Color.rgb(20, 20, 40),
      w,   0, Gosu::Color.rgb(10, 10, 30),
      0,   h, Gosu::Color.rgb(0, 0, 20),
      w,   h, Gosu::Color.rgb(0, 0, 10),
      0
    )

    # -----------------------------------
    # TITLE
    # -----------------------------------
    title = "PLAYER MODE"
    @title_font ||= Gosu::Font.new(48)
    tw = @title_font.text_width(title)
    @title_font.draw_text(title, (w - tw) / 2, 100, 10, 1, 1, Gosu::Color::RED)

    # -----------------------------------
    # OPTIONS
    # -----------------------------------
    base_y = 200
    @font ||= Gosu::Font.new(32)

    @options.each_with_index do |opt, i|
      text_w = @font.text_width(opt)
      x = (w - text_w) / 2
      y = base_y + i * 70

      selected = (i == @selected)

      # Highlight bar
      if selected
        pulse = 40 + Math.sin(Gosu.milliseconds / 150.0) * 20
        Gosu.draw_rect(x - 30, y - 10, text_w + 60, 60,
                       Gosu::Color.rgba(255, 255, 0, pulse.to_i), 5)
      end

      # Scale animation
      scale = selected ? 1.05 + Math.sin(Gosu.milliseconds / 200.0) * 0.03 : 1.0
      color = selected ? Gosu::Color::YELLOW : Gosu::Color::WHITE

      @font.draw_text(opt, x, y, 10, scale, scale, color)
    end

    # -----------------------------------
    # FOOTER HINT
    # -----------------------------------
    hint = "↑↓ to navigate   ENTER to select"
    hw = @font.text_width(hint)
    alpha = 180 + Math.sin(Gosu.milliseconds / 300.0) * 40
    hint_color = Gosu::Color.rgba(200, 200, 200, alpha.to_i)

    @font.draw_text(hint, (w - hw) / 2, h - 60, 10, 1, 1, hint_color)

  end
end