extends "res://addons/Inventory_Template/Scripts/Slot_extends.gd"


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		move_item(_event)
	
	if _event is InputEventMouseMotion:
		verific_distance(_event)



func move_item(_event) -> void:
	
	if verific_distance(_event):
		if get_child_count() >= 1:
			if Inventory.slot.node == null:
				if initial_moviment(): return
		
		if Inventory.support.system_button == Support.SYSTEM_BUTTON.MOBILE:
			if _event.pressed == false:
				end_moviment()
		else:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				end_moviment()


func initial_moviment():
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and Inventory.save_dat.item_no_slot == null:
		if Input.is_key_pressed(KEY_SHIFT):
			shift_move()
			return true
		
		set_slot_item()
		return true
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		create_item_void()
		return true


func end_moviment() -> void:
	if get_child_count() >= 1:
		transfer_item()
	else:
		move_void_item()
		
		Inventory.save_dat.item_no_slot = null
		Inventory.slot = {node = null,item = -1}
		Inventory.emit_signal("refresh_data")
	
	Inventory.verific_amount_item()
	Inventory.call_equipped_item(use_type)


