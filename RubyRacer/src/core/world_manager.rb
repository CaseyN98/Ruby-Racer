# core/world_manager.rb
require 'gosu'

class WorldManager
  attr_reader :chunk_size, :cols, :rows

  Chunk = Struct.new(:name, :gx, :gy, :map, :mask_blob)

  def initialize(layout, chunk_size: 2048)
    @layout     = layout
    @chunk_size = chunk_size
    @rows       = @layout.size
    @cols       = @layout.first.size
    @chunks     = {}

    preload_all_chunks
  end

  # ---------------------------------------------------------
  # LOAD ALL CHUNKS (map + mask)
  # ---------------------------------------------------------
  def preload_all_chunks
    @layout.each_with_index do |row, gy|
      row.each_with_index do |name, gx|
        next unless name

        map_path  = "assets/world/#{name}/#{name}.png"
        mask_path = "assets/world/#{name}/#{name}_mask.png"

        map_image  = Gosu::Image.new(map_path)
        mask_image = Gosu::Image.new(mask_path)
        mask_blob  = mask_image.to_blob

        @chunks[[gx, gy]] = Chunk.new(name, gx, gy, map_image, mask_blob)
      end
    end
  end

  def update(player_x, player_y)
    # (Streaming later — fine for now)
  end

  # ---------------------------------------------------------
  # DRAW WORLD (all chunks)
  # ---------------------------------------------------------
  def draw(cam_x, cam_y, screen_w, screen_h)
    @chunks.each_value do |chunk|
      world_x = chunk.gx * @chunk_size
      world_y = chunk.gy * @chunk_size

      # Simple culling
      next if world_x > cam_x + screen_w  || world_x + @chunk_size < cam_x
      next if world_y > cam_y + screen_h || world_y + @chunk_size < cam_y

      chunk.map.draw(world_x - cam_x, world_y - cam_y, 0)
    end
  end

  # ---------------------------------------------------------
  # CHUNK LOOKUP
  # ---------------------------------------------------------
  def chunk_for(x, y)
    gx = (x / @chunk_size).floor
    gy = (y / @chunk_size).floor
    @chunks[[gx, gy]]
  end

  # ---------------------------------------------------------
  # PIXEL READING (same API as Map#get_pixel)
  # ---------------------------------------------------------
  def get_pixel(x, y)
    chunk = chunk_for(x, y)
    return [1, 1, 1, 1] unless chunk

    lx = x - chunk.gx * @chunk_size
    ly = y - chunk.gy * @chunk_size

    return [1, 1, 1, 1] if lx < 0 || ly < 0 || lx >= @chunk_size || ly >= @chunk_size

    index = (ly * @chunk_size + lx) * 4
    bytes = chunk.mask_blob[index, 4]
    return [1, 1, 1, 1] unless bytes

    r, g, b, a = bytes.unpack("C*")
    [r / 255.0, g / 255.0, b / 255.0, a / 255.0]
  end

  # ---------------------------------------------------------
  # ROAD / WALL COLLISION (2‑color mask)
  # BLACK = road (0,0,0)
  # WHITE = wall (255,255,255)
  # ---------------------------------------------------------
def is_road_world?(x, y)
  r, g, b, a = get_pixel(x, y)
  brightness = (r + g + b) / 3.0

  brightness < 0.9   # black = road, white = wall
end
  # ---------------------------------------------------------
  # TYPE CHECK (minimal version for open world)
  # ---------------------------------------------------------
  def check_type(x, y, type)
    case type
    when :road
      is_road_world?(x, y)
    else
      false
    end
  end

  # ---------------------------------------------------------
  # WORLD SIZE
  # ---------------------------------------------------------
  def width
    @cols * @chunk_size
  end

  def height
    @rows * @chunk_size
  end
end