module InputDebug
  FONT = Gosu::Font.new(18)
  BUTTONS = (0..15).to_a

  def self.draw(x = 10, y = 10)
    line = 0

    write("=== INPUT DEBUG ===", x, y, line); line += 1
    write("Press P2 D-pad now", x, y, line); line += 2

    # --- Gp1 Buttons ---
    write("--- Gp1 Buttons ---", x, y, line); line += 1
    BUTTONS.each do |i|
      write("Gp1Button#{i}: #{Gosu.button_down?(Gosu.const_get("Gp1Button#{i}"))}", x, y, line)
      line += 1
    end

    # --- Gp1 POV ---
    pov1 = Gosu.input.pov_angle(1) rescue nil
    write("Gp1 POV angle: #{pov1.inspect}", x, y, line); line += 2

    # --- Gp2 Buttons ---
    write("--- Gp2 Buttons ---", x, y, line); line += 1
    BUTTONS.each do |i|
      write("Gp2Button#{i}: #{Gosu.button_down?(Gosu.const_get("Gp2Button#{i}"))}", x, y, line)
      line += 1
    end

    # --- Gp2 POV ---
    pov2 = Gosu.input.pov_angle(2) rescue nil
    write("Gp2 POV angle: #{pov2.inspect}", x, y, line); line += 1
  end

  def self.write(text, x, y, line)
    FONT.draw_text(text, x, y + line * 20, 999, 1, 1, Gosu::Color::YELLOW)
  end
end