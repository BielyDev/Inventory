extends PanelContainer

onready var Void : Node = $"%void"

func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		verific_distance()
	if _event is InputEventMouseButton:
		if verific_distance():
			discart()

func discart() -> void:
	if is_instance_valid(Inventory.slot.node):
		if Inventory.slot.node.equipped:
			Inventory.save_dat.equipped.erase(Inventory.search_item(Inventory.slot.item))
			Inventory.slot.node.get_child(0).queue_free()
			Inventory.slot = {node = null,item = -1}
		else:
			Inventory.save_dat.inventory.erase(Inventory.search_item(Inventory.slot.item))
			Inventory.slot.node.get_child(0).queue_free()
			Inventory.slot = {node = null,item = -1}
	if Inventory.save_dat.item_void != null:
		Void.get_child(0).queue_free()
		Inventory.save_dat.item_void = null

func verific_distance(): # Verifica a distancia.
	if get_global_mouse_position().distance_to(rect_global_position+rect_size/2) <= rect_size.x/2:
		self_modulate = Color.red
		return true
	else:
		self_modulate = Color.white
		return false
