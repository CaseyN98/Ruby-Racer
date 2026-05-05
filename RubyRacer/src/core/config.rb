#src/core/
module Config
  # Player mode (1P or 2P)
  @player_mode = :two_player

  def self.player_mode
    @player_mode
  end

  def self.player_mode=(mode)
    @player_mode = mode
  end

  # Default players (used to restore 2P mode)
  DEFAULT_PLAYERS = [
    { car_index: 0, hue: 0.0 },
    { car_index: 1, hue: 0.6 }
  ]

  # Active players (mutable)
  @players = DEFAULT_PLAYERS.map(&:dup)

  def self.players
    @players
  end

  def self.players=(arr)
    @players = arr
  end

  # Race settings
  RACE = {
    total_laps: 3,
    countdown: 3
  }
CARS = [
  { name: "Ripper v3",
    max_speed: 105, accel: 360, brake: 700, turn: 3.0,
    sprite: "assets/cars/car7.png" },

  { name: "Purp F1",
    max_speed: 150, accel: 520, brake: 750, turn: 4.4,
    sprite: "assets/cars/car11.png" },

  { name: "Ferrari F1 08",
    max_speed: 148, accel: 520, brake: 750, turn: 4.4,
    sprite: "assets/cars/car12.png" },

  { name: "Speedster",
    max_speed: 130, accel: 380, brake: 720, turn: 4.0,
    sprite: "assets/cars/car6.png" },

  { name: "GTI SL3",
    max_speed: 105, accel: 260, brake: 750, turn: 3.2,
    sprite: "assets/cars/car5.png" },

  { name: "Rugoti",
    max_speed: 115, accel: 330, brake: 720, turn: 3.6,
    sprite: "assets/cars/car4.png" },

  { name: "REV-X",
    max_speed: 125, accel: 350, brake: 800, turn: 3.8,
    sprite: "assets/cars/car1.png" },

  { name: "DRIFT-KING",
    max_speed: 135, accel: 300, brake: 650, turn: 5.4,
    sprite: "assets/cars/car2.png" },

  { name: "PO-LICE",
    max_speed: 145, accel: 340, brake: 720, turn: 4.6,
    sprite: "assets/cars/car3.png" },

  { name: "Thunderbolt",
    max_speed: 135, accel: 460, brake: 720, turn: 2.8,
    sprite: "assets/cars/car8.png" },

  { name: "SRS 300",
    max_speed: 95, accel: 280, brake: 900, turn: 2.6,
    sprite: "assets/cars/car9.png" },

  { name: "AMBUR-LANCE",
    max_speed: 70, accel: 200, brake: 800, turn: 3.4,
    sprite: "assets/cars/car10.png" }
]
  TRACKS = {
    track1: {
      name: "City Circuit",
      sprite_path: "assets/tracks/track1.png",
      mask_path: "assets/tracks/track1_mask.png",
      preview: "assets/tracks/track1_preview.png",
      start: { x: 1207, y: 1550, angle: Math::PI },
      waypoints: [
        { x: 500,  y: 1650 },
        { x: 500,  y: 800  },
        { x: 1800, y: 800  },
        { x: 1800, y: 1650 }
      ]
    },
    track2: {
      name: "Lakeside Drift",
      sprite_path: "assets/tracks/track2.png",
      mask_path: "assets/tracks/track2_mask.png",
      preview: "assets/tracks/track2_preview.png",
      start: { x: 1008, y: 1198, angle: Math::PI },
      waypoints: [
        { x: 500,  y: 1650 },
        { x: 500,  y: 800  },
        { x: 1800, y: 800  },
        { x: 1800, y: 1650 }
      ]
    },

    track3: {
      name: "Drag Race",
      sprite_path: "assets/tracks/track3.png",
      mask_path: "assets/tracks/track3_mask.png",
      preview: "assets/tracks/track3_preview.png",
      start: { x: 170, y: 1025, angle: 0 },
      waypoints: [
        { x: 400, y: 1400 },
        { x: 400, y: 600 },
        { x: 1600, y: 600 },
        { x: 1600, y: 1400 }
      ]
    },
    track4: {
      name: "Red's Circuit",
      sprite_path: "assets/tracks/track4.png",
      mask_path: "assets/tracks/track4_mask.png",
      preview: "assets/tracks/track4_preview.png",
      start: { x: 1900, y: 1800, angle: Math::PI },
      waypoints: [
        { x: 500,  y: 1650 },
        { x: 500,  y: 800  },
        { x: 1800, y: 800  },
        { x: 1800, y: 1650 }
      ]
    }
  }

  TRACK = { map_id: :track1 }
end
