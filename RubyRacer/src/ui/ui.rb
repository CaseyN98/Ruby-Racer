module UI
  UI_Z = 1000
  @font     = Gosu::Font.new(24)
  @big_font = Gosu::Font.new(72)

  def self.draw_player_ui(game, player, x_offset)
    return unless player
    h = $window.height

    box_x, box_y = x_offset + 10, h - 90
    box_w, box_h = 280, 80

    # UI Background
    Gosu.draw_rect(box_x, box_y, box_w, box_h, Gosu::Color.rgba(0,0,0,160), UI_Z - 10)

    # Stats
    @font.draw_text("SPD: #{(player.speed.abs/5).to_i}", box_x + 10, box_y + 10, UI_Z)
    @font.draw_text("LAP: #{player.lap}/#{Config::RACE[:total_laps]}", box_x + 10, box_y + 35, UI_Z, 1, 1, Gosu::Color::YELLOW)

    # Boost Bar
    fill = player.boost_timer > 0 ? player.boost_timer/1.5 : (player.has_boost ? 1.0 : 0.0)
    Gosu.draw_rect(box_x + 10, box_y + 60, 150, 10, Gosu::Color.rgba(50,50,50,255), UI_Z)
    Gosu.draw_rect(box_x + 10, box_y + 60, 150 * fill, 10, Gosu::Color::CYAN, UI_Z + 1)

    # Weapon Slot
    weap_box_x = box_x + box_w - 70
    Gosu.draw_rect(weap_box_x, box_y + 10, 60, 60, Gosu::Color.rgba(255,255,255,40), UI_Z)
    if player.weapon
      w_name = player.weapon.to_s.upcase
      @font.draw_text(w_name[0..5], weap_box_x + 5, box_y + 30, UI_Z + 1, 0.7, 0.7)
    end

    # Countdown
    if game.countdown > 0
      msg = game.countdown.ceil.to_s
      @big_font.draw_text(msg, x_offset + ($window.width/4) - 20, h/2 - 40, UI_Z, 1, 1, Gosu::Color::YELLOW)
    end
  end
end