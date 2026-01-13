extends CharacterBody2D

# health
@export var max_health := 100
var health := max_health

# Wander settings
@export var move_speed := 150.0
@export var wander_radius := 120.0
@export var wander_interval := 2.5

# chase settings
@export var melee_range := 64.0
@export var ranged_min_range := 300.0
@export var ranged_max_range := 600.0

# attack settings
@export var attack_damage := 20
@export var attack_cooldown := 1.2
@export var attack_frame := 3

var can_attack := true
var is_attacking := false

@export var is_ranged := false

@export var bullet_scene: PackedScene = null

# Internal
var player: Node2D = null
var prev_pos: Vector2
var spawn_position: Vector2
var wander_target: Vector2
var wander_timer := 0.0

# Enemy state
enum State {
	WANDER,
	CHASE
}

var state := State.WANDER

# onready
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

## --- built in methods ---

func _ready():
	spawn_position = global_position
	prev_pos = global_position
	pick_new_wander_target()
	
func _physics_process(delta):
	# Enemy behavior
	match state:
		State.WANDER:
			wander_behavior(delta)
		State.CHASE:
			chase_behavior(delta)
	
	move_and_slide()
	update_animation()
	
	## Update scale (don't update if velocity equals 0)
	if velocity.x < 0:
		animated_sprite.flip_h = true
		hitbox.position.x = -abs(hitbox.position.x)
	elif velocity.x > 0:
		animated_sprite.flip_h = false
		hitbox.position.x = abs(hitbox.position.x)

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
		
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack" and animated_sprite.frame == attack_frame:
		enable_hitbox()
	else:
		disable_hitbox()
		
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack":
		is_attacking = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

## --- public methods ---

# Take damage
func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	
	if health <= 0:
		# TODO handle lose
		queue_free()

# Change animation
func update_animation():
	if is_attacking:
		return
	
	if velocity.length() > 1:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

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
	# Check if doing attack animation
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	# Move towards player and attack
	if distance > melee_range:
		move_towards(player.global_position)
	else:
		velocity = Vector2.ZERO
		try_attack()

# Ranged behavior
func ranged_movement(distance):
	# Keep player within a certain range
	if distance > ranged_max_range:
		move_towards(player.global_position)
	elif distance < ranged_min_range:
		move_away_from(player.global_position)
	else:
		velocity = Vector2.ZERO
	try_ranged_attack()
		
# Attack sequence
func try_attack():
	if not can_attack:
		return
	
	# Set flags
	is_attacking = true
	can_attack = false
	
	# Play animation
	animated_sprite.play("attack")
	
# Ranged attack sequence
func try_ranged_attack():
	if not can_attack:
		return
	
	# Create bullet on timeout
	can_attack = false
	create_bullet()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func create_bullet() -> void:
	# Autoaim to player
	if (!player):
		return
	
	# Create bullet
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = (Vector2(0, -32) + player.global_position - bullet.global_position).angle()
	bullet.damage = attack_damage
	bullet.set_owner_enemy()
	get_parent().add_child(bullet)

## --- movement methods ---
# TODO change to use navmesh

func move_towards(target: Vector2):
	velocity = (target - global_position).normalized() * move_speed

func move_away_from(target: Vector2):
	velocity = (global_position - target).normalized() * move_speed

## --- hitbox methods ---

func _on_hitbox_area_entered(area: Area2D) -> void:
	var hurt_player = area.get_parent()
	if hurt_player and player.is_in_group("player"):
		player.take_damage(attack_damage)

func enable_hitbox():
	hitbox.monitoring = true

func disable_hitbox():
	hitbox.monitoring = false
