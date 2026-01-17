extends Level

@export var item_num := 5


func _ready() -> void:
	init_signals()
	
	item_library = []
	for items in PlayerInventory.item_library.values():
		for i in items:
			item_library.append(load(i))
	if terrain:
		spawn_items(item_num)
	PlayerInventory.generate_new_android_inventory()
