extends Node2D

@onready var line := $Line2D

@export var radius := 600.0
@export var segments := 32

func _ready():
	draw_targeting()

func draw_targeting():
	line.clear_points()

	for i in range(segments + 1):
		var t := float(i) / segments
		var angle = lerp(-PI / 2, PI / 2, t) # vertical arc, facing right
		var point := Vector2(cos(angle), sin(angle)) * radius
		line.add_point(point)
