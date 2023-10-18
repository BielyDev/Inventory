extends Button

export(String) var path : String
export(int) var amount : int = 1

func _pressed() -> void:
	if Inventory.verific_size(false,path):
		Inventory.call_add_item(path,amount,Inventory.instantiate_item(path).type)
