extends Button

export(String) var path : String
export(int) var amount : int = 1

func _pressed() -> void:
	if Autoload.verific_size(false,path):
		Autoload.call_add_item(path,amount)