extends CharacterBody2D
class_name Player

@onready var combat_component: Node2D = $CombatComponent
@onready var attack_timer: Timer = $AttackTimer

var move_speed := 200
var jump_height := 200
var facing := 1 # 1 = right, -1 = left

var arc_range: = 400.0

func _ready() -> void:
	attack_timer.timeout.connect(on_attack_timer_timeout)

	##Setting size of combat arc and redrawing
	combat_component.radius = arc_range
	combat_component.draw_targeting()

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

## Jumping
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_height

## Enemy detection
func is_in_combat_arc(target: Node2D, weapon_range: float) -> bool:
	var to_target := target.global_position - global_position

	# Distance check
	if to_target.length() > weapon_range:
		return false

	# Facing direction
	var forward := Vector2(facing, 0)

	# Angle check (dot product)
	return forward.dot(to_target.normalized()) >= 0

func on_attack_timer_timeout():
	attack()

func attack():
	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if is_in_combat_arc(enemy, arc_range):
			enemy.take_damage(10)
			print("Attack " + str(enemy))
