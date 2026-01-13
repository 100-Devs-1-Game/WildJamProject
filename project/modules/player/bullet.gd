extends RigidBody2D

# Bullet config
var speed: float = 500
var lifetime: float = 2
var damage: int = 10

# Owner
enum Owner {
	PLAYER,
	ENEMY
}
var owner_type = Owner.PLAYER

# onready
@onready var timer: Timer = $Timer
@onready var hitbox: Area2D = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(lifetime)
	match owner_type:
		Owner.PLAYER:
			hitbox.collision_mask = 1 << (CollisionLayers.ENEMY - 1)
		Owner.ENEMY:
			hitbox.collision_mask = 1 << (CollisionLayers.PLAYERHURTBOX - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Physics process
func _physics_process(delta: float) -> void:
	# Move bullet
	linear_velocity = transform.x * speed
	pass

# Collision
func _on_hitbox_body_entered(body: Node2D) -> void:
	# Damage
	try_damage(body)
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	# Damage
	var hurt_entity = area.get_parent()
	try_damage(hurt_entity)
	
# Try damaging
func try_damage(hurt_entity: Node) -> void:
	if hurt_entity and (hurt_entity.is_in_group("enemies") or hurt_entity.is_in_group("player")):
		hurt_entity.take_damage(damage)
	
	queue_free()

# Timeout
func _on_timer_timeout() -> void:
	queue_free()

## --- public methods ---

# Set owner to enemy
func set_owner_enemy() -> void:
	owner_type = Owner.ENEMY

# Set owner to player
func set_owner_player() -> void:
	owner_type = Owner.PLAYER
