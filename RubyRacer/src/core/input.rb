module Input
  DEADZONE = 0.2

  # -----------------------------
  # Player 1 + Player 2 Gamepad Mapping
  # -----------------------------
  GAMEPAD = [
    { # PLAYER 1
      id: 0,
      left:   Gosu::Gp0DpadLeft,
      right:  Gosu::Gp0DpadRight,
      up:     Gosu::Gp0DpadUp,
      down:   Gosu::Gp0DpadDown,

      accel:  Gosu::Gp0Button0,
      brake:  Gosu::Gp0Button1,
      boost:  Gosu::Gp0Button2,
      weapon: Gosu::Gp0Button3
    },

    { # PLAYER 2 (Sega controller worked here)
      id: 1,
      left:   Gosu::Gp1DpadLeft,
      right:  Gosu::Gp1DpadRight,
      up:     Gosu::Gp1DpadUp,
      down:   Gosu::Gp1DpadDown,

      accel:  Gosu::Gp1Button0,
      brake:  Gosu::Gp1Button1,
      boost:  Gosu::Gp1Button2,
      weapon: Gosu::Gp1Button3
    }
  ]

  # -----------------------------
  # Keyboard Mapping
  # -----------------------------
  KEYBINDS = [
    { # PLAYER 1
      left:   Gosu::KB_A,
      right:  Gosu::KB_D,
      up:     Gosu::KB_W,
      down:   Gosu::KB_S,
      accel:  Gosu::KB_W,
      brake:  Gosu::KB_S,
      boost:  Gosu::KB_SPACE,
      weapon: Gosu::KB_LEFT_SHIFT
    },

    { # PLAYER 2
      left:   Gosu::KB_LEFT,
      right:  Gosu::KB_RIGHT,
      up:     Gosu::KB_UP,
      down:   Gosu::KB_DOWN,
      accel:  Gosu::KB_UP,
      brake:  Gosu::KB_DOWN,
      boost:  Gosu::KB_RIGHT_SHIFT,
      weapon: Gosu::KB_RETURN
    }
  ]

  # -----------------------------
  # Steering
  # -----------------------------
  def self.steer(player = 0)
    gp = GAMEPAD[player]

    # Gamepad
    return -1 if Gosu.button_down?(gp[:left])
    return  1 if Gosu.button_down?(gp[:right])

    # Keyboard
    kb = KEYBINDS[player]
    return -1 if Gosu.button_down?(kb[:left])
    return  1 if Gosu.button_down?(kb[:right])

    0
  end

  # -----------------------------
  # Throttle
  # -----------------------------
  def self.throttle(player = 0)
    gp = GAMEPAD[player]
    kb = KEYBINDS[player]

    return 1 if Gosu.button_down?(gp[:up])
    return 1 if Gosu.button_down?(gp[:accel])
    return 1 if Gosu.button_down?(kb[:up])
    return 1 if Gosu.button_down?(kb[:accel])

    0
  end

  # -----------------------------
  # Brake / Reverse
  # -----------------------------
  def self.brake(player = 0)
    gp = GAMEPAD[player]
    kb = KEYBINDS[player]

    return 1 if Gosu.button_down?(gp[:down])
    return 1 if Gosu.button_down?(gp[:brake])
    return 1 if Gosu.button_down?(kb[:down])
    return 1 if Gosu.button_down?(kb[:brake])

    0
  end

  def self.reverse(player = 0)
    brake(player)
  end

  # -----------------------------
  # Boost / Weapon
  # -----------------------------
  def self.use_boost(player = 0)
    gp = GAMEPAD[player]
    kb = KEYBINDS[player]
    Gosu.button_down?(gp[:boost]) || Gosu.button_down?(kb[:boost])
  end

  def self.use_weapon(player = 0)
    gp = GAMEPAD[player]
    kb = KEYBINDS[player]
    Gosu.button_down?(gp[:weapon]) || Gosu.button_down?(kb[:weapon])
  end
  def self.sega_axis_left?(id)
    Gosu.axis(0, id) rescue 0 < -0.3
  end

  def self.sega_axis_right?(id)
    Gosu.axis(0, id) rescue 0 > 0.3
  end

  def self.sega_axis_up?(id)
    Gosu.axis(1, id) rescue 0 < -0.3
  end

  def self.sega_axis_down?(id)
    Gosu.axis(1, id) rescue 0 > 0.3
  end

  # -----------------------------
  # Menu Navigation (original)
  # -----------------------------
  def self.up
    Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::Gp0DpadUp) || Gosu.button_down?(Gosu::Gp1DpadUp)
  end

  def self.down
    Gosu.button_down?(Gosu::KB_DOWN) || Gosu.button_down?(Gosu::Gp0DpadDown) || Gosu.button_down?(Gosu::Gp1DpadDown)
  end

  def self.left
    Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::Gp0DpadLeft) || Gosu.button_down?(Gosu::Gp1DpadLeft)
  end

  def self.right
    Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::Gp0DpadRight) || Gosu.button_down?(Gosu::Gp1DpadRight)
  end

  def self.confirm
    Gosu.button_down?(Gosu::KB_RETURN) || Gosu.button_down?(Gosu::Gp0Button0) || Gosu.button_down?(Gosu::Gp1Button0)
  end

  def self.back
    Gosu.button_down?(Gosu::KB_ESCAPE) || Gosu.button_down?(Gosu::Gp0Button1) || Gosu.button_down?(Gosu::Gp1Button1)
  end
end