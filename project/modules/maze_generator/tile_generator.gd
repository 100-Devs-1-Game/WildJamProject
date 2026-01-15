class_name Tile_generator
extends Node2D 

# width and height for the maze
var num_col: int
var num_row: int

# minimum size for each "tile"
# tiles must be  bigger by area in percentage AND total number of tiles
@export var min_tile_percent: float = 0.01
@export var min_tile_total: int = 9

var map: Array
var tilelist: Array[Tile]

## Create a new empty map and tilelist
func setup(rows : int, cols : int):
	num_col = cols
	num_row = rows
	map = []
	for row in rows:
		map.append([])
		for col in cols:
			map[row].append(0)
	tilelist = []
	tilelist.append(Tile.new(rows,cols, Vector2i.ZERO))

## Populate map with random seeding of cells
func gen_tileset():
	for tile in tilelist:
		tile.gen_tile_set()
		for row in tile.num_rows:
			for col in tile.num_cols:
				map[row + tile.map_coords.y][col + tile.map_coords.x] = tile.mapsection[row][col]

## Use Cellular Automata to generate pathways [br]
## Based on B5/S1234
func cellular_automata():
	var newmap = []
	for row in num_row:
		newmap.append([])
		for col in num_col:
			var alive_neighbours = 0
			for subrow in range(-1,2):
				for subcol in range(-1,2):
					if row+subrow == row and col +subcol == col:
						continue
					elif row + subrow < 0 or row + subrow >= num_row or col + subcol < 0 or col + subcol >= num_col:
						continue
					else:
						if map[row+subrow][col+subcol] == 1:
							alive_neighbours += 1
			if alive_neighbours >= 5 or alive_neighbours < 1:
				newmap[row].append(0)
			elif alive_neighbours == 3:
				newmap[row].append(1)
			else:
				newmap[row].append(map[row][col])
	map = newmap
	queue_redraw()

## Add in extra cells post CA, to create nicer corners in the maze. [br]
## Can leave the maze feeling too filled in if too much is smoothed out
func smooth():
	for row in num_row-1:
		for col in num_col-1:
			# 01   looking for a pattern like this
			# 10
			if map[row][col] == 0 and map[row+1][col] == 1 and map[row][col+1] == 1 and map[row+1][col+1] == 0:
				map[row][col] = 1
			# 10   looking for a pattern like this   
			# 01
			elif map[row][col] == 1 and map[row+1][col] == 0 and map[row][col+1] == 0 and map[row+1][col+1] == 1:
				map[row][col+1] = 1	
	queue_redraw()

## Split tiles into two smaller tiles recursively. [br]
## Uses Binary Partition Tree principles [br]
## Start with 1 tile spanning whole map.
func split():
	_split(tilelist.pop_front())

## Split tiles into two smaller tiles recursively. [br]
## Uses Binary Partition Tree principles [br]
func _split(current_tile : Tile):
	#adjust the randge to add more varience to tile sizes
	var splitval = randf_range(0.4, 0.7)
	# Base case is a tile is at or below minimum size (area or total size)
	if(current_tile.num_rows * current_tile.num_cols <= max(num_row * num_col *min_tile_percent,9)):
		tilelist.append(current_tile)
		return
	elif(current_tile.num_rows >= current_tile.num_cols):
		_split(Tile.new(floor(current_tile.num_rows*splitval), 
			current_tile.num_cols, 
			Vector2i(current_tile.map_coords))
			)
		_split(Tile.new(ceil(current_tile.num_rows*(1-splitval)), 
			current_tile.num_cols, 
			Vector2i(current_tile.map_coords.x, current_tile.map_coords.y + floor(current_tile.num_rows * splitval)))
			)
	else:
		_split(Tile.new(current_tile.num_rows,
			floor(current_tile.num_cols*splitval), 
			Vector2i(current_tile.map_coords))
			)
		_split(Tile.new(current_tile.num_rows,
			ceil(current_tile.num_cols*(1-splitval)), 
			Vector2i(current_tile.map_coords.x + floor(current_tile.num_cols * splitval), current_tile.map_coords.y ))
			)


func _draw():
	#Temporary draw function to visualise the int map, can scrap later when we have actual sprites to use
	var windowsize = get_viewport().get_visible_rect().size
	var blockwidth = windowsize.x/num_col
	var blockheight = windowsize.y/num_row
	for current_tile in tilelist:
		for row in current_tile.num_rows:
			for col in current_tile.num_cols:
				if map[row+current_tile.map_coords.y][col+current_tile.map_coords.x] == 1:
					draw_rect(Rect2((col+current_tile.map_coords.x) *blockwidth, (row+current_tile.map_coords.y)*blockheight, blockwidth,blockheight), Color.WHEAT)
				else:
					draw_rect(Rect2((col+current_tile.map_coords.x) *blockwidth, (row+current_tile.map_coords.y)*blockheight, blockwidth,blockheight), Color.BLACK)
