extends Node

signal refresh_itens() # Usado para reiniciar itens_buttons em slots.
signal refresh_data() # Quando acontecer quaisquer mudança de dados esta função será chamada para a verificação e varredura.
signal discart_item(item_dictionary)# item : Dictionary
signal equipped_item(item_dictionary) #item : Dictionary
signal unequip_item(tem_dictionary) #item : Dictionary

enum TYPE {null,GUN,ACCESSORY,HELMET,ENCHANTMENT,CHESTPLATE,BOOTS}

var type_array : Array = []
var itens_size : int = 12

# Save_dat é um dicionario com informações prestes a seram salvas em um arquivo.
var save_dat = {
	inventory = [{id = 0,slot = 0,amount = 5,type = 2,path = "res://addons/Inventory_Template/Scenes/Itens/Potion_life.tscn"}],
	equipped = [],
	body = {},
	
	item_no_slot = null
}

# Slot serve para salvar dados do slot transitor(o slot e item que está sendo arrastado pelo mouse).
var slot : Dictionary = {
	node = null,
	item = -1,
}


func verific_amount_item() -> void:
	for item_inventory in save_dat.inventory:
		if item_inventory.amount <= 0:
			emit_signal("refresh_itens")
			save_dat.inventory.erase(item_inventory)
	
	for item_equip in save_dat.equipped:
		if item_equip.amount <= 0:
			emit_signal("refresh_itens")
			save_dat.equipped.erase(item_equip)


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


func search_item(id : int = -1, path : String = "",equipped : bool = false): # Procura o item com id especificado.
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


func search_item_slot(slot: int,equipped: bool): #Procura o item no slot especificado.
	if equipped:
		for itens in save_dat.equipped:
			if itens.slot == slot:
				return itens
	else:
		for itens in save_dat.inventory:
			if itens.slot == slot:
				return itens


func instantiate_item(item: String):
	var new_item = load(item).instance()
	return new_item


func call_add_item(path: String, amount: int = 1, type_index: int = 0, search: bool = true, id_reset: bool = false,slot_index = null,equipped: bool = false):
	
	if search == true:
		var item = search_item(-1,path)
		if item != null:
			item.amount += amount
			
			emit_signal("refresh_itens")
			return item.id
	
	if save_dat.size() >= itens_size:
		return "maximum_item"
	
	var id_rand = int(randi())
	if id_reset == true:
		id_rand = -1
	
	if equipped == false:
		if slot_index == null:save_dat.inventory.append({id = id_rand,slot = procure_slot(true),amount = amount,type = type_index,path = path})
		else:save_dat.inventory.append({id = id_rand,slot = slot_index,amount = amount,type = type_index,path = path})
	else:
		if slot_index == null:save_dat.equipped.append({id = id_rand,slot = procure_slot(false),amount = amount,type = type_index,path = path})
		else:save_dat.equipped.append({id = id_rand,slot = slot_index,amount = amount,type = type_index,path = path})
	
	emit_signal("refresh_itens")
	return id_rand


func call_equipped_item(): # Atualiza os itens do corpo
	
	for body in type_array:
		var exist_item: bool = false
		
		for itens in save_dat.equipped:
			if body.path == itens.path:
				exist_item = true
		
		if exist_item == false:
			emit_signal("unequip_item",body)
			type_array.erase(body)
	
	
	for itens in save_dat.equipped:
		for typecons in TYPE.values():
			if typecons != null and itens.type == typecons:
				itens_body_gun(itens,typecons)


func itens_body_gun(item,type_num: int) -> void:
	for itens in type_array:
		if itens.type == type_num:
			return
	
	type_array.append(item)
	emit_signal("equipped_item",item)


func procure_slot(equipped: bool):
	var dic = []
	
	if equipped:
		for itens in save_dat.inventory:
			dic.append(itens.slot)
		
	else:
		for itens in save_dat.equipped:
			dic.append(itens.slot)
	
	dic.sort()
	for num in dic.size():
		if num != dic[num]:
			return num
	return dic.size()

