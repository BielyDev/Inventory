extends Button

export(String) var path_item_scene : String
export(int) var amount : int = 1

func _pressed() -> void:
	if Inventory.verific_size(false,path_item_scene):
		Inventory.call_add_item(
			path_item_scene,
			amount,
			Inventory.instantiate_item(path_item_scene).type
		)
	
