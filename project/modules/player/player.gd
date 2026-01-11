extends CharacterBody2D

@export_group("Movement Settings")
@export var walk_speed: float = 300.0

# # added a sprint for testing (TODO: decide if we want to keep and if so, add SP consumption)
@export var sprint_speed: float = 500.0

# accelaration to simulate player running up (increase it to reduce effect)
@export var acceleration: float = 2000.0

# speed to deaccelerate (if we want to add different terrain modifiers in the future - decreasse it for ice, for exaple)
@export var friction: float = 3000.0 

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("MOVEMENT_LEFT", "MOVEMENT_RIGHT", "MOVEMENT_UP", "MOVEMENT_DOWN")
	var current_max_speed = walk_speed
	if Input.is_action_pressed("MOVEMENT_SPRINT"):
		current_max_speed = sprint_speed
	
	# uses move_toward for smooth movement
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * current_max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
