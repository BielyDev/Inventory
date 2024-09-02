extends Node

signal refresh_itens() # Usado para reiniciar itens_buttons em slots.
signal refresh_data() # Quando acontecer quaisquer mudança de dados esta função será chamada para a verificação e varredura.
signal item_data(item) 
signal discart_item(item_dictionary)# item : Dictionary
signal equipped_item(item_dictionary) #item : Dictionary
signal unequip_item(tem_dictionary) #item : Dictionary
signal removed_item(tem_dictionary) #item : Dictionary

enum TYPE {null,GUN,ACCESSORY,HELMET,ENCHANTMENT,CHESTPLATE,BOOTS}

var itens_size : int = 12
var type_array : Array = []
var support: Support

# Save_dat é um dicionario com informações prestes a seram salvas em um arquivo.
var save_dat = {
	inventory = [{id = 0,slot = 0,amount = 5,type = 2,resource_path = "res://addons/Inventory_Template/Scenes/Itens/Potion_life.tscn"}],
	equipped = [],
	body = {},
	
	item_no_slot = null
}

# Slot serve para salvar dados do slot transitor(o slot e item que está sendo arrastado pelo mouse).
var slot : Dictionary = {
	node = null,
	item = -1,
}


func _ready() -> void:
	support = Support.new()
	add_child(support)


func verific_amount_item() -> void:
	for item_inventory in save_dat.inventory:
		if item_inventory.amount <= 0:
			emit_signal("refresh_itens")
			
			emit_signal("removed_item",item_inventory)
			save_dat.inventory.erase(item_inventory)
	
	for item_equip in save_dat.equipped:
		if item_equip.amount <= 0:
			emit_signal("refresh_itens")
			
			emit_signal("removed_item",item_equip)
			save_dat.equipped.erase(item_equip)


func verific_size(equipped:bool,resource_path = ""):
	if resource_path != null:
		if search_item(-1,resource_path,equipped) != null:
			return true
	if equipped:
		if save_dat.equipped.size() >= itens_size:
			return false
	else:
		if save_dat.inventory.size() >= itens_size:
			return false
	return true


func search_item(id : int = -1, resource_path : String = "",equipped : bool = false): # Procura o item com id especificado.
	if equipped == true:
		if resource_path != "":
			for itens in save_dat.equipped:
				if itens.resource_path == resource_path: return itens
			return null
		
		for itens in save_dat.equipped:
			if itens.id == id: return itens
		return null
	
	if resource_path != "":
		for itens in save_dat.inventory:
			if itens.resource_path == resource_path: return itens
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


func call_add_item(resource_path: String, amount: int = 1, type_index: int = 0, search: bool = true, id_reset: bool = false,slot_index = null,equipped: bool = false):
	
	if search == true:
		var item = search_item(-1,resource_path)
		if item != null:
			item.amount += amount
			
			emit_signal("refresh_data")
			return item.id
	
	#if save_dat.size() >= itens_size:
	#	return "maximum_item"
	
	var id_rand = int(randi())
	if id_reset:
		id_rand = -1
	
	var item: Dictionary
	
	if equipped == false:
		
		item = {id = id_rand,slot = slot_index,amount = amount,type = type_index,resource_path = resource_path}
		
		if slot_index == null:
			item.slot = procure_slot(true)
		
		save_dat.inventory.append(item)
	else:
		
		item = {id = id_rand,slot = slot_index,amount = amount,type = type_index,resource_path = resource_path}
		
		if slot_index == null:
			item.slot = procure_slot(false)
		
		save_dat.equipped.append(item)
	
	emit_signal("item_data",item)
	return id_rand


func call_equipped_item(use_types: bool): # Atualiza os itens do corpo
	
	for body in type_array:
		var exist_item: bool = false
		
		for itens in save_dat.equipped:
			if body.resource_path == itens.resource_path:
				exist_item = true
		
		if exist_item == false:
			emit_signal("unequip_item",body)
			type_array.erase(body)
	
	
	if use_types:
		for itens in save_dat.equipped:
			for typecons in TYPE.values():
				if typecons != null and itens.type == typecons:
					itens_body_item(itens,typecons)
	#else:
	#	for itens in save_dat.equipped:
	#		itens_id_body_item(itens,instance_itens)


func itens_body_item(item,type_num: int) -> void:
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


func change_amount(item: Dictionary, change: int):
	item.amount += change
	
	Inventory.verific_amount_item()
	
	emit_signal("refresh_data")


