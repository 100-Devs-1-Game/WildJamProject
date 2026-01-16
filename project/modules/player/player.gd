class_name IsometricPlayer
extends CharacterBody2D

@export_group("Movement Settings")
@export var walk_speed: float = 300.0

# # added a sprint for testing (TODO: decide if we want to keep and if so, add SP consumption)
@export var sprint_speed: float = 500.0

# accelaration to simulate player running up (increase it to reduce effect)
@export var acceleration: float = 2000.0

# speed to deaccelerate (if we want to add different terrain modifiers in the future - decreasse it for ice, for exaple)
@export var friction: float = 3000.0 

# bullet scene
@export var bullet_scene: PackedScene = null

# aiming angle
@export var aim_dir: Vector2 = Vector2.RIGHT

# rate of firing bullets
@export var shoot_rate: float = 1

@onready var bullet_timer: Timer = $BulletTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var model: Node2D = $Model
# the model assets are tiny, it'll be scaled up by default
@onready var model_scale: float = model.scale.x
@onready var shoulder: Node2D = %Shoulder


# health
@export var max_health := 100
var health := max_health
var invincible := false

# ammo
@export var max_ammo := 100
var ammo := max_ammo

var target_enemy: Node2D


func _ready() -> void:
	bullet_timer.wait_time= shoot_rate
	_post_ready.call_deferred() 
	
func _post_ready():
	# ensure the HUD is fully loaded before setting the initial values
	Signals.change_ammo_count_value.emit(ammo, max_ammo)
	Signals.change_health_value.emit(health, max_health)
	

func _process(_delta: float) -> void:
	var looking_right := global_position.x < get_global_mouse_position().x
	model.scale.x = model_scale if looking_right else -model_scale 
	
	if not is_instance_valid(target_enemy):
		target_enemy= null
		
	if target_enemy:
		shoulder.look_at(target_enemy.global_position)
	else:
		shoulder.rotation = 0

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down").normalized()
	# Since this is an isometric perspective, reduce vertical movement, assuming a 45 degree camera, the movement is halved
	input_vector.y *= 0.5
	var current_max_speed = walk_speed
	if Input.is_action_pressed("movement_sprint"):
		current_max_speed = sprint_speed
	
	# uses move_toward for smooth movement
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * current_max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	# assign aim dir based on mouse position
	var mouse_dir = global_position.direction_to(get_global_mouse_position())
	aim_dir = Vector2.RIGHT if mouse_dir.x >= 0 else Vector2.LEFT
	
	move_and_slide()
	
	if velocity.length() < 1:
		animation_player.play("RESET")
	else:
		if not animation_player.is_playing():
			animation_player.play("walk")

	# Autoaim to nearest enemy
	target_enemy = get_nearest_enemy_from_aim(aim_dir)
	if target_enemy and bullet_timer.is_stopped():
		shoot()

func shoot():
	# Create bullets in aim_dir
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	if target_enemy != null:
		bullet.rotation = (target_enemy.global_position - bullet.global_position).angle()
	else:
		bullet.rotation = aim_dir.angle()
	bullet.set_owner_player()
	get_parent().add_child(bullet)
	Signals.change_ammo_count_value.emit(ammo, max_ammo)	
	bullet_timer.start()

func _on_bullet_timer_timeout() -> void:
	if ammo <= 0:
		return
	ammo -= 1

	if target_enemy:
		shoot()

# Get nearest enemy based on aim vector
func get_nearest_enemy_from_aim(check_dir: Vector2) -> Node2D:
	var nearest_enemy = null
	var shortest_dist = INF
	
	# Find closest object in enemies group
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		# Get difference
		var to_enemy = enemy.global_position - global_position
		
		# Check if enemy is on the same side as the snapped_vector
		if check_dir.dot(to_enemy) > 0:
			# Check if closest
			var dist = to_enemy.length()
			if dist < shortest_dist:
				shortest_dist = dist
				nearest_enemy = enemy
				
	return nearest_enemy


func pickup_item(item: Item):
	# TODO apply item properties to the player
	Signals.item_picked_up.emit(item)
	ammo += 100

# Take damage
func take_damage(amount: int):
	if invincible:
		return
	
	health -= amount
	health = max(health, 0)
	Signals.change_health_value.emit(health, max_health)
	
	if health <= 0:
		# TODO handle lose
		queue_free()
	else:
		start_iframes()
		
		
		
		

# Toggle iframes
func start_iframes():
	invincible = true
	await get_tree().create_timer(0.5).timeout
	invincible = false
