require 'chingu'
require_relative '../core/config'
require_relative '../core/input'
require_relative '../core/game'
require_relative '../ui/ui'

class TrackSelect < Chingu::GameState
  def initialize
    super

    @tracks = Config::TRACKS.keys
    @index  = @tracks.index(Config::TRACK[:map_id]) || 0

    @title_font = Gosu::Font.new(48)
    @font       = Gosu::Font.new(28)
    @small      = Gosu::Font.new(22)

    # Cache preview images
    @previews = {}
    @tracks.each do |tid|
      path = Config::TRACKS[tid][:preview]
      @previews[tid] = Gosu::Image.new(path) if path
    end

    @input_timer = 300
  end

  def update
    super
    @input_timer -= $window.dt if @input_timer > 0
    return if @input_timer > 0

    if Input.left
      @index = (@index - 1) % @tracks.length
      @input_timer = 200

    elsif Input.right
      @index = (@index + 1) % @tracks.length
      @input_timer = 200

    elsif Input.confirm
      Config::TRACK[:map_id] = @tracks[@index]

      # Only change laps if Track 3 is selected
      if Config::TRACK[:map_id] == :track3
        Config::RACE[:total_laps] = 1
      else
        Config::RACE[:total_laps] = 4
      end

      push_game_state(Game)
      @input_timer = 300

    elsif Input.back
      pop_game_state
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
    title = "SELECT TRACK"
    tw = @title_font.text_width(title)
    tx = (w - tw) / 2
    ty = 60

    @title_font.draw_text(title, tx + 2, ty + 2, 9, 1, 1, Gosu::Color::BLACK)
    @title_font.draw_text(title, tx, ty, 10, 1, 1, Gosu::Color::YELLOW)

    # -----------------------------------
    # TRACK NAME WITH HIGHLIGHT
    # -----------------------------------
    track_id = @tracks[@index]
    track    = Config::TRACKS[track_id]
    name     = track[:name]

    nw = @font.text_width(name)
    nx = (w - nw) / 2
    ny = 180

    # Soft highlight behind name
    Gosu.draw_rect(nx - 20, ny - 10, nw + 40, 50,
                   Gosu::Color.rgba(255, 255, 255, 20), 5)

    @font.draw_text(name, nx, ny, 10, 1, 1, Gosu::Color::WHITE)

    # -----------------------------------
    # PREVIEW IMAGE WITH FRAME
    # -----------------------------------
    preview = @previews[track_id]
    if preview
      scale = 0.3
      pw = preview.width * scale
      ph = preview.height * scale
      px = (w - pw) / 2
      py = 250

      # Frame
      Gosu.draw_rect(px - 20, py - 20, pw + 40, ph + 40,
                     Gosu::Color.rgba(255, 255, 255, 20), 5)

      preview.draw(px, py, 10, scale, scale)
    end

    # -----------------------------------
    # LEFT/RIGHT ARROWS (animated)
    # -----------------------------------
    pulse = 150 + Math.sin(Gosu.milliseconds / 200.0) * 105
    arrow_color = Gosu::Color.rgba(255, 255, 0, pulse.to_i)

    @font.draw_text("◄", px - 80, py + ph / 2 - 20, 10, 1.2, 1.2, arrow_color)
    @font.draw_text("►", px + pw + 40, py + ph / 2 - 20, 10, 1.2, 1.2, arrow_color)

    # -----------------------------------
    # FOOTER INSTRUCTIONS (animated fade)
    # -----------------------------------
    alpha = 180 + Math.sin(Gosu.milliseconds / 300.0) * 40
    hint_color = Gosu::Color.rgba(200, 200, 200, alpha.to_i)

    @small.draw_text("← →  Change Track",  w / 2 - 400, h - 120, 10, 1, 1, hint_color)
    @small.draw_text("ENTER to Start Race", w / 2 - 400, h - 80,  10, 1, 1, hint_color)
    @small.draw_text("ESC to Go Back",      w / 2 - 400, h - 40,  10, 1, 1, hint_color)
  end
end