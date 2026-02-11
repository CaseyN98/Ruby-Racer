# main.rb
require 'gosu'
require 'chingu'
require_relative 'src/core/input'
require_relative 'src/core/game'
require_relative 'src/ui/menu'
require_relative 'src/core/audio'

class Main < Chingu::Window
  def initialize
    super(960, 540, false)
    self.caption = "RubyRacer"
    Audio.load
    Audio.play_music
    push_game_state(Menu)
  end

  def update
    super  # Chingu handles state updates
  end
end

Main.new.show