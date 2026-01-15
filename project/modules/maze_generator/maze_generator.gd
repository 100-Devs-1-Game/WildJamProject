class_name MazeGenerator

static var map: Array

static func generate_maze(width: int, height: int, force_safe_zone: bool = false, safe_zone_pos: Vector2i = Vector2i.ZERO):
	var tile_gen := TileGenerator.new()
	tile_gen.setup(width, height)
	tile_gen.split()
	tile_gen.gen_tileset()
	for x in range(0,10):
		tile_gen.cellular_automata()
	tile_gen.smooth()
	
	map = []
	for y in height:
		map.append([])
		for x in width:
			map[-1].append(true if tile_gen.map[x][y] else false)
			
	if force_safe_zone:
		for x in range(-1, 2):
			for y in range(-1, 2):
				map[safe_zone_pos.x + x][safe_zone_pos.y + y] = true
