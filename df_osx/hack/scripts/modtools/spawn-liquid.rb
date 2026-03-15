#  spawns water or lava at the specified coords
#  written by thefriendlyhacker
=begin

modtools/spawn-liquid
=====================
This script spawns liquid at the given coordinates.

Run ``modtools/spawn-liquid help`` for usage.

=end

def print_help()
  puts "modtools/spawn-liquid height liquid x y z xOff yOff zOff"
  puts "  height: height of the water/magma (1 to 7)"
  puts "  liquid: either water or magma, spawns that liquid"
  puts "  x y z: the location to spawn liquid at (replacing any preexisting liquid)"
  puts "  xOff yOff zOff: optional convenience offsets, added to x,y,z"
  puts "square brackets are ignored (so [ 0 0 -1 ] would be treated as 0 0 -1)"
  puts "note - in other scripts, \\\\LOCATION or similar is usually equivalent to x y z"
end

if $script_args.any?{ |arg| arg == "help" or arg == "?" or arg == "-?" } or $script_args.count < 1
  print_help()
  throw :script_finished
end

args = $script_args
# user might put in square brackets around coords, ignore these
args.delete_if {|arg| arg=='[' or arg==']'}
height = args[0].to_i
# liquid is handled later
x = args[2].to_i
y = args[3].to_i
z = args[4].to_i
if args.count>=5
  x += args[5].to_i
end
if args.count>=6
  y += args[6].to_i
end
if args.count>=7
  z += args[7].to_i
end

tile = df.map_tile_at(x, y, z)
if tile.shape_passableflow
  case args[1]
  when 'magma'
    tile.spawn_magma(height)
  when 'water'
    tile.spawn_water(height)
  end
end
