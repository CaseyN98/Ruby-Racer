require 'gosu'

# Input and output paths
INPUT_PATH  = "assets/tracks/track4.png"
OUTPUT_PATH = "assets/tracks/track4_mask.png"

# Load original image
original = Gosu::Image.new(INPUT_PATH)
width  = original.width
height = original.height

# Get raw pixel data
pixels = original.to_blob

# Create blank output buffer
mask_data = "\xFF" * (width * height * 4)
mask_data.force_encoding(Encoding::BINARY)

(0...width).each do |x|
  (0...height).each do |y|
    index = (y * width + x) * 4
    r, g, b, a = pixels[index, 4].unpack("C*")

    # Detect road (dark gray)
    brightness = (r + g + b) / 3.0
    is_road = brightness < 80  # tweak this threshold as needed

    if is_road
      mask_data[index, 4] = [0, 0, 0, 255].pack("C*")  # black
    else
      mask_data[index, 4] = [255, 255, 255, 255].pack("C*")  # white
    end
  end
end

# Save mask image
Gosu::Image.from_blob(width, height, mask_data).save(OUTPUT_PATH)
puts "Mask saved to #{OUTPUT_PATH}"