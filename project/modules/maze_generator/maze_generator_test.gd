extends Node2D

@export var width: int = 50
@export var height: int = 50
@export var pixel_size: int= 8


func _init() -> void:
	MazeGenerator.generate_maze(width, height, true, Vector2.ONE)

func _draw() -> void:
	for x in width:
		for y in height:
			var pos := Vector2(x, y) * pixel_size
			if MazeGenerator.map[x][y]:
				draw_rect(Rect2(pos, Vector2.ONE * pixel_size), Color.RED)
	
