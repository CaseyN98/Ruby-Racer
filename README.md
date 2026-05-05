RUBY RACER - PIXEL RACING GAME
A fast, retro-style top-down racing game built in Ruby using Gosu and Chingu.
Features include split-screen multiplayer, custom cars, custom maps, AI racers, and a fully modular codebase designed for easy expansion.

FEATURES
CORE GAMEPLAY
• 	Smooth top-down physics
• 	Acceleration, braking, drifting, turning
• 	Pixel-art cars with customizable stats
• 	Lap tracking, checkpoints, finish detection
• 	Boost pads and off-road slowdown
• 	AI racers using waypoint navigation
SPLIT-SCREEN MULTIPLAYER
• 	Supports 1-player or 2-player modes
• 	Player-specific controls (keyboard and gamepad)
• 	Independent car selection for each player (10 Cars so far!)
• 	Independent camera tracking for each screen half
CAR SELECTION
• 	Live stat preview (speed, accel, turn, brake)
• 	Car sprite preview
• 	Supports adding new cars through config.rb
TRACK SYSTEM
• 	Custom track PNGs with collision masks
• 	Waypoint-based AI navigation
• 	Road and off-road detection
• 	Easy to add new tracks through config.rb
MODULAR ARCHITECTURE core/      engine, input, config, game loop gameplay/  car, map, track select, car select, race logic ui/        menus, HUD, overlays assets/    cars, tracks, masks, fonts

CONTROLS (Both players have gampad controls)
PLAYER 1 Steer Left: A Steer Right: D Throttle: W Brake/Reverse: S Menu Confirm: Enter or Space Menu Back: Escape Gamepad 0: Left Stick, Button 0 (accelerate), Button 1 (brake)
PLAYER 2 Steer Left: Left Arrow Steer Right: Right Arrow Throttle: Up Arrow Brake/Reverse: Down Arrow Menu Confirm: Enter or Space Menu Back: Escape Gamepad 1: Left Stick, Button 0 (accelerate), Button 1 (brake)

INSTALLATION
Requirements:
• 	Ruby 3.x
• 	Gosu (gem install gosu)
• 	Chingu (gem install chingu)
Clone the project: git clone  (github.com in Bing) cd ruby-racer
Run the game: ruby main.rb

PROJECT STRUCTURE
core/ camera.rb config.rb game.rb input.rb
gameplay/ car.rb car_select.rb map.rb race_over.rb stats.rb track_select.rb
ui/ menu.rb player_mode_menu.rb ui.rb high scores.txt
assets/ car sprites track images track masks fonts

ADDING NEW CARS
1. 	Open core/config.rb
2. 	Add a new entry to the CARS array:
Example: { name: "DRIFT-KING", max_speed: 500, accel: 700, brake: 900, turn: 6.0, sprite: "assets/car2.png" }
3. 	Add the PNG to the assets folder. The car will automatically appear in the Car Select screen.

ADDING NEW TRACKS
1. 	Add your track PNG to the assets folder.
2. 	Add a collision mask PNG (white = road, black = wall).
3. 	Add a new entry to TRACKS in config.rb:
Example: track2: { name: "Lakeside Drift", sprite_path: "assets/track2.png", mask_path: "assets/track2_mask.png", start: { x: 900, y: 1400, angle: Math::PI / 2 }, waypoints: [ { x: 400, y: 1400 }, { x: 400, y: 600 }, { x: 1600, y: 600 }, { x: 1600, y: 1400 } ] }
4. 	The track will appear in Track Select automatically.

AI SYSTEM
• 	Uses waypoint steering
• 	Calculates angle difference to target
• 	Clamps steering input
• 	Uses throttle control
• 	Automatically progresses through waypoints

UI AND HUD
• 	Split-screen rendering
• 	Lap counter
• 	Speed display
• 	Timer and best lap tracking
• 	Race over screen with results

DEVELOPMENT NOTES
• 	Modular input system (keyboard and gamepad)
• 	Velocity-based collision system (vx, vy)
• 	Data-driven car and track definitions
• 	Clean require_relative structure
• 	Designed for easy modding and expansion

LICENSE
MIT License (or your preferred license)

CREDITS
Code and design: OleReadHead with the help of copilot and ruby ide
Engine: Ruby, Gosu, Chingu
Pixel art: Ulises Freitas Arludus

