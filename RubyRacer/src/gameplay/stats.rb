# stats.rb
require "time"

module Stats
  SAVE_FILENAME = "highscores.txt"

  @last_race = {
    total_time:   0.0,
    best_lap_time: 0.0,
    lap_count:     0,
    date:          ""
  }

  class << self
    attr_reader :last_race
  end

  # ------------------------------
  # SAVE RACE RESULTS
  # ------------------------------
  def self.save_race(race_state)
    @last_race[:total_time]   = race_state[:race_time]     || 0
    @last_race[:best_lap_time] = race_state[:best_lap_time] || 0
    @last_race[:lap_count]     = race_state[:current_lap]   || 0
    @last_race[:date]          = Time.now.strftime("%Y-%m-%d %H:%M")

    data = <<~TEXT
      TotalTime:#{format("%.2f", @last_race[:total_time])}
      BestLap:#{format("%.2f", @last_race[:best_lap_time])}
      Laps:#{@last_race[:lap_count]}
      Date:#{@last_race[:date]}
    TEXT

    begin
      File.write(SAVE_FILENAME, data)
    rescue => e
      puts "Could not save stats: #{e}"
    end
  end

  # ------------------------------
  # LOAD LAST RACE
  # ------------------------------
  def self.load_last_race
    return nil unless File.exist?(SAVE_FILENAME)

    contents = File.read(SAVE_FILENAME)
    contents.each_line do |line|
      key, val = line.strip.split(":", 2)
      next unless key && val

      case key
      when "TotalTime" then @last_race[:total_time]   = val.to_f
      when "BestLap"   then @last_race[:best_lap_time] = val.to_f
      when "Laps"      then @last_race[:lap_count]     = val.to_i
      when "Date"      then @last_race[:date]          = val
      end
    end

    @last_race
  end

  # ------------------------------
  # GET LAST RACE (same as Lua)
  # ------------------------------
  def self.get_last_race
    @last_race
  end
end