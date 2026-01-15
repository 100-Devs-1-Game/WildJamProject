class_name MazeGenerator


static func generate_maze(width: int, height: int, force_safe_zone: bool = false, safe_zone_pos: Vector2i = Vector2i.ZERO):
	var tile_gen := TileGenerator.new()
	tile_gen.setup(width, height)
	tile_gen.split()
	tile_gen.gen_tileset()
	for x in range(0,10):
		tile_gen.cellular_automata()
	tile_gen.smooth()
