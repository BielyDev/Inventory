extends "res://addons/Inventory_Template/Scripts/Slot_extends.gd"


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		move_item()
	if _event is InputEventMouseMotion:
		verific_distance()


func move_item() -> void:
	if verific_distance():
		if get_child_count() >= 1 and Inventory.slot.node == null:
			if initial_moviment(): return
		
		end_moviment()


func end_moviment() -> void:
		if Input.is_action_just_pressed("left_click"):
			if get_child_count() >= 1:
				transfer_item()
				
			else:
				move_void_item()
				
				Inventory.save_dat.item_no_slot = null
				Inventory.slot = {node = null,item = -1}
				Inventory.emit_signal("refresh_data")
			
			Inventory.verific_amount_item()
			Inventory.call_equipped_item()


func initial_moviment():
	if Input.is_action_just_pressed("left_click") and Inventory.save_dat.item_no_slot == null:
		set_slot_item()
		return true
	if Input.is_action_just_pressed("right_click"):
		create_item_void()
		return true
