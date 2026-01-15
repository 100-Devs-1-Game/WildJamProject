extends Level

@export var item_num := 5


func _ready() -> void:
	item_library = []
	for i in PlayerInventory.item_library:
		item_library.append(load(i))
	if terrain:
		spawn_items(item_num)
