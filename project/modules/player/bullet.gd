extends RigidBody2D

# Bullet config
var speed: float = 500
var lifetime: float = 2
var damage: int = 10

# Timer
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(lifetime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Physics process
func _physics_process(delta: float) -> void:
	# Move bullet
	linear_velocity = transform.x * speed
	pass

# Collision
func _on_body_entered(body: Node) -> void:
	queue_free()

# Timeout
func _on_timer_timeout() -> void:
	queue_free()
