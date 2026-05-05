require 'gosu'

# Input and output paths
INPUT_PATH  = "C:/Users/Casey/Desktop/Game/rubyprojects/RubyRacer/assets/world/city2/city2.png"
OUTPUT_PATH = "C:/Users/Casey/Desktop/Game/rubyprojects/RubyRacer/assets/world/city2/city2_mask.png"

# Threshold for road detection
ROAD_BRIGHTNESS = 80

# Load original image
original = Gosu::Image.new(INPUT_PATH)
width  = original.width
height = original.height

pixels = original.to_blob

mask_data = "\xFF" * (width * height * 4)
mask_data.force_encoding(Encoding::BINARY)

(0...height).each do |y|
  (0...width).each do |x|
    index = (y * width + x) * 4
    r, g, b, a = pixels[index, 4].unpack("C*")

    brightness = (r + g + b) / 3.0
    is_road = brightness < ROAD_BRIGHTNESS

    if is_road
      mask_data[index, 4] = [0, 0, 0, 255].pack("C*")   # road
    else
      mask_data[index, 4] = [255, 255, 255, 255].pack("C*") # off-road
    end
  end

  puts "Processed row #{y}/#{height}" if y % 200 == 0
end

Gosu::Image.from_blob(width, height, mask_data).save(OUTPUT_PATH)
puts "Mask saved to #{OUTPUT_PATH}"