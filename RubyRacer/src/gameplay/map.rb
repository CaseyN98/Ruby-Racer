# map.rb
require_relative '../core/config'
require 'gosu'
require_relative 'boost_pickup'
require_relative 'weapon_pickup'

class Map
  attr_reader :image, :mask_width, :mask_height, :boost_pickups, :weapon_pickups

  def initialize(id)
    load_track(id)
    @boost_pickups  = []
    @weapon_pickups = []

    scan_for_boost_pickups
    scan_for_weapon_pickups
  end

  # ------------------------------
  # LOAD MAP + MASK
  # ------------------------------
  def load_track(id)
    track = Config::TRACKS[id]
    raise "Track #{id} not found in Config" unless track

    @image = Gosu::Image.new(track[:sprite_path])

    mask_img = Gosu::Image.new(track[:mask_path])
    @mask_width  = mask_img.width
    @mask_height = mask_img.height

    @mask_data = mask_img.to_blob
  end

  # ------------------------------
  # READ PIXEL (returns floats 0..1)
  # ------------------------------
  def get_pixel(x, y)
    ix = x.to_i
    iy = y.to_i

    return [1, 1, 1, 1] if ix < 0 || iy < 0 || ix >= @mask_width || iy >= @mask_height

    index = (iy * @mask_width + ix) * 4
    bytes = @mask_data[index, 4]
    return [1, 1, 1, 1] unless bytes

    r, g, b, a = bytes.unpack("C*")
    [r / 255.0, g / 255.0, b / 255.0, a / 255.0]
  end

  # ------------------------------
  # COLOR‑BASED TYPE CHECK
  # ------------------------------
  def check_type(x, y, type)
    r, g, b, a = get_pixel(x, y)

    case type
    when :road
      brightness = (r + g + b) / 3.0

      # Treat magenta (weapon) and blue (boost) as road
      is_weapon_tile = (r > 0.8 && b > 0.8 && g < 0.2)
      is_boost_tile  = (b > 0.8 && r < 0.2 && g < 0.2)

      brightness < 0.4 || is_weapon_tile || is_boost_tile

    when :checkpoint
      (g - r) > 0.25 && (g - b) > 0.25

    when :finish
      (r - g) > 0.25 && (r - b) > 0.25

    else
      false
    end
  end

  # ------------------------------
  # ROAD / WALL COLLISION
  # ------------------------------
  def is_road_world?(x, y)
    r, g, b, a = get_pixel(x, y)
    brightness = (r + g + b) / 3.0

    # Allow weapon + boost tiles as road
    is_weapon_tile = (r > 0.8 && b > 0.8 && g < 0.2)
    is_boost_tile  = (b > 0.8 && r < 0.2 && g < 0.2)

    brightness < 0.95 || is_weapon_tile || is_boost_tile
  end

  def area_check(x, y, radius, type)
    (-radius..radius).each do |dx|
      (-radius..radius).each do |dy|
        return true if check_type(x + dx, y + dy, type)
      end
    end
    false
  end

  # ------------------------------
  # SCAN MASK FOR WEAPON PICKUPS
  # ------------------------------
  def scan_for_weapon_pickups
    @weapon_pickups = []
    tile_size = 32

    (0...@mask_width).step(tile_size) do |x|
      (0...@mask_height).step(tile_size) do |y|
        r, g, b, a = get_pixel(x + 16, y + 16)

        if r > 0.8 && b > 0.8 && g < 0.2
          @weapon_pickups << WeaponPickup.new(x + 16, y + 16)
        end
      end
    end
  end

  # ------------------------------
  # SCAN MASK FOR BOOST PICKUPS
  # ------------------------------
  def scan_for_boost_pickups
    @boost_pickups = []
    tile_size = 32

    (0...@mask_width).step(tile_size) do |x|
      (0...@mask_height).step(tile_size) do |y|
        r, g, b, a = get_pixel(x + 16, y + 16)

        if b > 0.8 && r < 0.2 && g < 0.2
          @boost_pickups << BoostPickup.new(x + 16, y + 16)
        end
      end
    end
  end

  # ------------------------------
  # DRAW MAP
  # ------------------------------
  def draw
    @image&.draw(0, 0, 0)
  end
end