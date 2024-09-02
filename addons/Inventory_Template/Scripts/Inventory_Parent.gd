extends Control

#More signal in Inventory.gd
signal moved_item()
signal discart_item()

func _on_Inventory_hide() -> void:
	Inventory.slot = {node = null, item = -1,}
	
	if Inventory.save_dat.item_no_slot != null:
		var slot = Inventory.procure_slot(false)
		
		Inventory.call_add_item(Inventory.save_dat.item_no_slot.resource_path,Inventory.save_dat.item_no_slot.amount)
	
	Inventory.save_dat.item_no_slot = null
