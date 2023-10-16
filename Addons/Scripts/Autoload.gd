extends Node

signal add_item

var itens_size : int = 12

var save_dat = {
	inventory = [{id = 0,slot = 0,amount = 5,path = "res://Addons/Scenes/itens/potion_life.tscn"}],
	equipped = [],
	item_void = null
}

var slot : Dictionary = {
	node = null,
	item = -1,
}

func verific_amount_item() -> void:
	for item in save_dat.inventory:
		if item.amount <= 0:
			save_dat.inventory.erase(item)
	
	for equipped in save_dat.equipped:
		if equipped.amount <= 0:
			save_dat.equipped.erase(equipped)
	emit_signal("add_item")

func verific_size(equipped:bool,path = ""):
	if path != null:
		if search_item(-1,path,equipped) != null:
			return true
	if equipped:
		if save_dat.equipped.size() >= itens_size:
			return false
	else:
		if save_dat.inventory.size() >= itens_size:
			return false
	return true

func search_item(id : int = -1, path : String = "",equipped : bool = false):
	
	if equipped == true:
		if path != "":
			for itens in save_dat.equipped:
				if itens.path == path: return itens
			return null
		
		for itens in save_dat.equipped:
			if itens.id == id: return itens
		return null
	
	if path != "":
		for itens in save_dat.inventory:
			if itens.path == path: return itens
		return null
	
	for itens in save_dat.inventory:
		if itens.id == id: return itens

func call_add_item(path : String, amount : int = 1,search : bool = true,id_reset = false,slot_index = null,equipped = false):
	if search == true:
		var item = search_item(-1,path)
		if item != null:
			item.amount += amount
			emit_signal("add_item")
			return item.id
	
	if save_dat.size() >= itens_size:
		return "maximum_item"
	
	var id_rand = int(randi())
	if id_reset == true:
		id_rand = -1
	
	if equipped == false:
		if slot_index == null:save_dat.inventory.append({id = id_rand,slot = procure_slot(),amount = amount,path = path})
		else:save_dat.inventory.append({id = id_rand,slot = slot_index,amount = amount,path = path})
	else:
		if slot_index == null:save_dat.equipped.append({id = id_rand,slot = procure_slot(),amount = amount,path = path})
		else:save_dat.equipped.append({id = id_rand,slot = slot_index,amount = amount,path = path})
	
	emit_signal("add_item")
	
	return id_rand

func procure_slot():
	var dic = []
	
	for itens in save_dat.inventory:
		dic.append(itens.slot)
	dic.sort()
	
	for num in dic.size():
		if num != dic[num]:
			return num
	return dic.size()
