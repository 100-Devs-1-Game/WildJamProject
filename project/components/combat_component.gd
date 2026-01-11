extends Node2D
class_name CombatComponent

@onready var line := $Line2D

## Radius set in player to allow upgrades
@export var radius := 400.0
@export var segments := 32

func _ready():
	draw_targeting()

func draw_targeting():
	line.clear_points()

	# Starting point to allow to close
	line.add_point(Vector2.ZERO)

	for i in range(segments + 1):
		var t := float(i) / segments
		var angle = lerp(-PI / 2, PI / 2, t) # vertical arc, facing right
		var point := Vector2(cos(angle), sin(angle)) * radius
		line.add_point(point)

	# Close back to origin
	line.add_point(Vector2.ZERO)
