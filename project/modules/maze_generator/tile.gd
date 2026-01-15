class_name Tile
extends  Node2D

var num_rows: int
var num_cols: int
var map_coords: Vector2i
var mapsection: Array

#How likely a cell is to start populated
@export var threshold: float = 0.5


func gen_tile_set():
	mapsection = []
	for row in num_rows:
		mapsection.append([])
		for col in num_cols:
			mapsection[row].append(0)
	for row in num_rows:
		for col in num_cols:
			var chance := randf_range(0, 1)
			mapsection[row][col] = 1 if chance > threshold else 0

func _init(rows: int, cols: int, coords: Vector2i):
	num_rows = rows
	num_cols = cols
	map_coords = coords
	
