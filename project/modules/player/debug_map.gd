extends Level

@export var item_num := 5


func _ready() -> void:
	if terrain:
		spawn_items(item_num)
