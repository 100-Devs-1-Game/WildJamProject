extends CharacterBody2D

@onready var combat_component: Node2D = $CombatComponent

var move_speed := 200
var jump_height := 200
var facing := 1 # 1 = right, -1 = left

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_axis("move_left", "move_right")

	# Move
	velocity.x = input_direction * move_speed

	# Detect facing
	if input_direction != 0:
		facing = sign(input_direction)
		combat_component.scale.x = facing

	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_height
