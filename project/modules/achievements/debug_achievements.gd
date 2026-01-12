extends Node2D

# Debug that will trigger achievements one after another on timeout

@export var debug_achs: Array[AchievementData]
var debug_idx: int = 0

func _on_timer_timeout() -> void:
	if debug_idx < debug_achs.size():
		Signals.achievement_trigger.emit(debug_achs[debug_idx])
		debug_idx += 1
