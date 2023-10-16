extends PanelContainer

onready var Void : Node = $"%void"

func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		verific_distance()
	if _event is InputEventMouseButton:
		if verific_distance():
			discart()

func discart() -> void:
	if is_instance_valid(Autoload.slot.node):
		if Autoload.slot.node.equipped:
			Autoload.save_dat.equipped.erase(Autoload.search_item(Autoload.slot.item))
			Autoload.slot.node.get_child(0).queue_free()
			Autoload.slot = {node = null,item = -1}
		else:
			Autoload.save_dat.inventory.erase(Autoload.search_item(Autoload.slot.item))
			Autoload.slot.node.get_child(0).queue_free()
			Autoload.slot = {node = null,item = -1}
	if Autoload.save_dat.item_void != null:
		Void.get_child(0).queue_free()
		Autoload.save_dat.item_void = null

func verific_distance(): # Verifica a distancia.
	if get_global_mouse_position().distance_to(rect_global_position+rect_size/2) <= rect_size.x/2:
		self_modulate = Color.red
		return true
	else:
		self_modulate = Color.white
		return false
