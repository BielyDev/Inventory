extends Node

signal refresh_itens() # Usado para reiniciar itens_buttons em slots.
signal refresh_data() # Quando acontecer quaisquer mudança de dados esta função será chamada para a verificação e varredura.
signal discart_item(item_dictionary)# item : Dictionary
signal equipped_item(item_dictionary) #item : Dictionary
signal unequip_item(tem_dictionary) #item : Dictionary

enum TYPE {null,GUN,ACCESSORY,HELMET,ENCHANTMENT,CHESTPLATE,BOOTS}

var itens_size : int = 12

# Save_dat é um dicionario com informações prestes a seram salvas em um arquivo.
var save_dat = {
	inventory = [{id = 0,slot = 0,amount = 5,type = 2,path = "res://addons/Inventory_Template/Scenes/Itens/Potion_life.tscn"}],
	equipped = [],
	body = {gun = null,
			accessory = null,
			helmet = null,
			enchantment = null,
			chestplate = null,
			boots = null},
	
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
		if slot_index == null:save_dat.inventory.append({id = id_rand,slot = procure_slot(),amount = amount,type = type_index,path = path})
		else:save_dat.inventory.append({id = id_rand,slot = slot_index,amount = amount,type = type_index,path = path})
	else:
		if slot_index == null:save_dat.equipped.append({id = id_rand,slot = procure_slot(),amount = amount,type = type_index,path = path})
		else:save_dat.equipped.append({id = id_rand,slot = slot_index,amount = amount,type = type_index,path = path})
	
	emit_signal("refresh_itens")
	return id_rand


func call_equipped_item(): # Atualiza os itens do corpo
	var arr_body = [save_dat.body]
	for body in save_dat.body:
		var bd = save_dat.body.get(body)
		var exist_item: bool = false
		
		for itens in save_dat.equipped:
			
			if bd != null and bd.id == itens.id:
				exist_item = true
		
		if bd != null and exist_item == false:
			emit_signal("unequip_item",bd)
			save_dat.body.merge({str(body) : null},true)
	
	for itens in save_dat.equipped:
		
		match itens.type:
			0:
				return false
			1:
				save_dat.body.gun = itens
				emit_signal("equipped_item",itens)
			2:
				save_dat.body.accessory = itens
				emit_signal("equipped_item",itens)
			3:
				save_dat.body.helmet = itens
				emit_signal("equipped_item",itens)
			4:
				save_dat.body.enchantment = itens
				emit_signal("equipped_item",itens)
			5:
				save_dat.body.chestplate = itens
				emit_signal("equipped_item",itens)
			6:
				save_dat.body.boots = itens
				emit_signal("equipped_item",itens)


func procure_slot():
	var dic = []
	
	for itens in save_dat.inventory:
		dic.append(itens.slot)
	dic.sort()
	
	for num in dic.size():
		if num != dic[num]:
			return num
	return dic.size()

