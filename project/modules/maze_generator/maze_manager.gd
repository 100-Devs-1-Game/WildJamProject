class_name maze_manager
extends Node2D

@export var maze_size_x: int = 50
@export var maze_size_y: int = 50

@onready var tile_gen: tile_generator = $tile_generator

## Generates a new maze [br]
## Note: will overwrite old maze stored
func generate_maze():
	tile_gen.setup(maze_size_x,maze_size_y)
	tile_gen.split()
	tile_gen.gen_tileset()
	for x in range(0,10):
		tile_gen.cellular_automata()
	tile_gen.smooth()

## Returns the map, if one exists, else blank map
func get_map() -> Array:
	if tile_gen.map:
		return tile_gen.map
	else:
		return tile_gen.setup(maze_size_x,maze_size_y)

func _ready() -> void:
	generate_maze()
	
