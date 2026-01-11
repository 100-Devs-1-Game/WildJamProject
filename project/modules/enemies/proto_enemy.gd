extends CharacterBody2D
class_name ProtoEnemy

var health = 100

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	move_and_slide()

func take_damage(amount):
	health -= amount

	if health <= 0:
		queue_free()
