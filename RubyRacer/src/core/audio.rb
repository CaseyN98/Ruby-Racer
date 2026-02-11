module Audio
  def self.load
    @boost = Gosu::Sample.new("assets/audio/boost.mp3")
    @rev   = Gosu::Sample.new("assets/audio/rev.mp3")
    @crash = Gosu::Sample.new("assets/audio/crash.mp3")
    @song  = Gosu::Song.new("assets/audio/song.wav")
    @boost_volume = 2.0
    @sfx_volume = 0.0
    @music_volume = 0.0
  end

  # Return raw samples (for looping)
  def self.rev_sample
    @rev
  end
  def self.sfx_volume
    @sfx_volume
  end
  # Normal one-shot SFX
  def self.rev
    @rev.play(@sfx_volume)
  end

  def self.boost
    @boost.play(@sfx_volume * @boost_volume)
  end

  def self.crash
    @crash.play(@sfx_volume)
  end

  def self.play_music
    @song.volume = @music_volume
    @song.play(true)
  end
end