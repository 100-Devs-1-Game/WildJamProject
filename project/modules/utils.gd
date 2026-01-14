class_name Utils
extends RefCounted

static func random_vec2(ref: Vector2) -> Vector2:
	return Vector2(
		(randf()-0.5) * ref.x, 
		(randf()-0.5) * ref.y, 
	)
