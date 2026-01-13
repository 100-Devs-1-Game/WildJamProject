extends CharacterBody2D

# Wander settings
@export var move_speed := 150.0
@export var wander_radius := 120.0
@export var wander_interval := 2.5

# chase settings
@export var melee_range := 24.0
@export var ranged_min_range := 300.0
@export var ranged_max_range := 600.0

@export var is_ranged := true

# Internal
var player: Node2D = null
var spawn_position: Vector2
var wander_target: Vector2
var wander_timer := 0.0

# Enemy state
enum State {
	WANDER,
	CHASE
}

var state := State.WANDER

## --- built in methods ---

func _ready():
	spawn_position = global_position
	pick_new_wander_target()
	
func _physics_process(delta):
	# Enemy behavior
	match state:
		State.WANDER:
			wander_behavior(delta)
		State.CHASE:
			chase_behavior(delta)

	move_and_slide()

func _on_detection_range_body_entered(body: Node2D) -> void:
	# Start chasing player
	if body.is_in_group("player"):
		player = body
		state = State.CHASE


func _on_detection_range_body_exited(body: Node2D) -> void:
	# Stop chasing player
	if body == player:
		player = null
		state = State.WANDER

## --- public methods ---

# Gets a random local point tow ander to
func pick_new_wander_target():
	wander_timer = wander_interval
	wander_target = spawn_position + Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)

# Behavior for wandering
func wander_behavior(delta):
	wander_timer -= delta

	if wander_timer <= 0 or global_position.distance_to(wander_target) < 8:
		pick_new_wander_target()

	move_towards(wander_target)

# Behavior for chasing
func chase_behavior(delta):
	if not player:
		state = State.WANDER
		return

	var distance := global_position.distance_to(player.global_position)

	if is_ranged:
		ranged_movement(distance)
	else:
		melee_movement(distance)

# Melee behavior
func melee_movement(distance):
	# Move towards player and attack
	if distance > melee_range:
		move_towards(player.global_position)
	else:
		velocity = Vector2.ZERO
		# TODO attack aith anim

# Ranged behavior
func ranged_movement(distance):
	# Keep player within a certain range
	if distance > ranged_max_range:
		move_towards(player.global_position)
	elif distance < ranged_min_range:
		move_away_from(player.global_position)
	else:
		velocity = Vector2.ZERO
		# TODO launch projectiles

## --- movement methods ---
# TODO change to use navmesh

func move_towards(target: Vector2):
	velocity = (target - global_position).normalized() * move_speed

func move_away_from(target: Vector2):
	velocity = (global_position - target).normalized() * move_speed
