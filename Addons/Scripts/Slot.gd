extends PanelContainer

onready var Void : Node = $"%void"

export (bool) var equipped : bool = false
export (int,"null","gun","accessory","capacete","costas","camisa","botas") var body : int = 0

var new_item_button : PackedScene = preload("res://Addons/Scenes/item_button.tscn")
var new_item_void_button : PackedScene = preload("res://Addons/Scenes/item_void_button.tscn")
var item_id : int = -1

func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		move_item()
	if _event is InputEventMouseMotion:
		verific_distance()

func move_item() -> void:
	
	if verific_distance() and get_child_count() >= 1 and Inventory.slot.node == null:
		if Input.is_action_just_pressed("left_click") and Inventory.save_dat.item_void == null:
			Inventory.slot.item = item_id
			Inventory.slot.node = self
			return
		if Input.is_action_just_pressed("right_click"):
			create_item_void()
	
	if Input.is_action_just_pressed("left_click") and verific_distance():
		if get_child_count() >= 1:
			transfer_item()
		else:
			move_void_item()
		Inventory.verific_amount_item()

func create_item_void() -> void: #VERIFIQUE ONDE ESTA CRIANDO A NOVA INSTANCIA DE BOTAO, ELE SEMPRE SERA O PRIMEIRO DA LISTA
	var my_item = Inventory.search_item(item_id,"",equipped)
	
	if my_item != null and Inventory.save_dat.item_void != null and Inventory.save_dat.item_void.path != my_item.path:
		var save_item = (Inventory.save_dat.item_void)
		var new_item = Inventory.call_add_item(
			save_item.path, 
			save_item.amount,
			save_item.type,
			false,false,get_index(),equipped)
		
		if equipped:Inventory.save_dat.equipped.erase(my_item)
		else:Inventory.save_dat.inventory.erase(my_item)
		
		Inventory.save_dat.item_void = my_item
		
		get_child(0).queue_free()
		Void.get_child(0).refresh_icon()
		
		#Inventory.slot.node.item_id = item_id
		item_id = Inventory.search_item(new_item,"",equipped).id
		Inventory.slot = {node = null,item = -1}
		add_button(new_item,self,get_index())
		return
	
	if Inventory.save_dat.item_void == null:
		my_item.amount -= 1
		
		Inventory.save_dat.item_void = {id = my_item.id,
			path = my_item.path,
			type =  my_item.type,
			slot = -1,amount = 1}
		
		var item_button = new_item_void_button.instance()
		Void.add_child(item_button)
		
	else:
		if Inventory.save_dat.item_void.path == my_item.path:
			my_item.amount -= 1
			Inventory.save_dat.item_void.amount += 1
		else:
			Inventory.save_dat.item_void = {id = my_item.id,
				type = my_item.type,
				path = my_item.path,
				slot = -1,amount = 1}
	
	Void.get_child(0).refresh_icon()
	get_child(0).refresh()

func verific_distance(): # Verifica a distancia.
	var moupos = get_global_mouse_position()
	if moupos.distance_to(rect_global_position + rect_size / 2) <= rect_size.x / 2:
		self_modulate.a = 3
		return true
	else:
		self_modulate.a = 1
		return false

func add_void_button() -> void:
	var new_item = Inventory.call_add_item(
		Inventory.save_dat.item_void.path,
		Inventory.save_dat.item_void.amount,
		Inventory.save_dat.item_void.type,
		false,false,null,equipped)
	
	Inventory.save_dat.item_void = null
	add_button(new_item,self,get_index())

func move_void_item() -> void: #Movimenta um item para um outro slot vazio.
	if Inventory.save_dat.item_void != null:
		
		add_void_button()
		
		Inventory.slot = {node = null,item = -1}
		return
	
	if Inventory.slot.item != -1:
		if verific_equipped() == false:
			Inventory.slot = {node = null,item = -1}
			return
		
		add_button(Inventory.slot.item,self,get_index())
		
		item_id = Inventory.slot.item
		Inventory.slot.node.item_id = -1
		Inventory.slot.node.get_child(0).queue_free()
	Inventory.slot = {node = null,item = -1}

func transfer_item() -> void: #Movimenta um item para um slot ja preenchido, e faz a troca.
	
	if Inventory.save_dat.item_void != null: #Item que não tem Slot é considerado Item Void
		var my_item =  Inventory.search_item(item_id,"",equipped)
		
		if Inventory.save_dat.item_void.path == my_item.path:
			my_item.amount += 1
			Inventory.save_dat.item_void.amount -= 1
			
			return
		else:
			var save_item = (Inventory.save_dat.item_void)
			var new_item = Inventory.call_add_item(
					save_item.path, 
					save_item.amount,
					save_item.type,
					false,false,null,equipped)
			
			if equipped:Inventory.save_dat.equipped.erase(my_item)
			else:Inventory.save_dat.inventory.erase(my_item)
			
			Inventory.save_dat.item_void = my_item
			
			get_child(0).queue_free()
			Void.get_child(0).refresh_icon()
			add_button(new_item,self,get_index())
			
			item_id = Inventory.search_item(new_item,"",equipped).id
			Inventory.slot = {node = null,item = -1}
			return
		
		var new_item = Inventory.call_add_item(
			Inventory.save_dat.item_void.path,
			Inventory.save_dat.item_void.amount,
			Inventory.save_dat.item_void.type,
			false,false,null,equipped)
		
		Void.get_child(0).queue_free()
		Inventory.save_dat.item_void = null
		add_button(new_item,self,get_index())
		item_id = new_item
		Inventory.slot = {node = null,item = -1}
		return
	
	if is_instance_valid(Inventory.slot.node):
		if Inventory.slot.node != self:
			var my_item =  Inventory.search_item(item_id,"",equipped)
			var other_item = Inventory.search_item(Inventory.slot.item,"",equipped)
			#--
			if other_item == null:
				other_item = Inventory.search_item(Inventory.slot.item,"",!equipped)
			
			if other_item.path == my_item.path:
				my_item.amount += other_item.amount
				other_item.amount = 0
				Inventory.slot = {node = null,item = -1}
				return
			else:
				#-
				if verific_equipped(false) == false:
					Inventory.slot = {node = null,item = -1}
					return
				
				Inventory.slot.node.get_child(0).queue_free()
				get_child(0).queue_free()
				
				#--
				
				add_button(item_id,Inventory.slot.node,other_item.slot)
				Inventory.slot.node.add_button(Inventory.slot.item,self,get_index())
				
				if equipped != Inventory.slot.node.equipped:
					if equipped:
						Inventory.save_dat.inventory.append(my_item)
						Inventory.save_dat.equipped.append(other_item)
						
						Inventory.save_dat.equipped.erase(my_item)
						Inventory.save_dat.inventory.erase(other_item)
					else:
						Inventory.save_dat.equipped.append(my_item)
						Inventory.save_dat.inventory.append(other_item)
						
						Inventory.save_dat.inventory.erase(my_item)
						Inventory.save_dat.equipped.erase(other_item)
				
				
				Inventory.slot.node.item_id = item_id
				item_id = Inventory.slot.item
				Inventory.slot = {node = null,item = -1}
		else: Inventory.slot = {node = null,item = -1}

func verific_equipped(refresh: bool = true):
	var verific_item = Inventory.search_item(Inventory.slot.item,"",!equipped)
	
	if equipped == true:
		
		if verific_item != null:
			if body != 0 and verific_item.type != body:
				return false
		
		else:
			var verific_item2 = Inventory.search_item(Inventory.slot.item,"",equipped)
			if verific_item2 != null:
				if verific_item2.type != body:
					return false
		
		if Inventory.search_item(Inventory.slot.item,"",true):
			return true
		if refresh:
			Inventory.save_dat.equipped.append(verific_item)
			Inventory.save_dat.inventory.erase(verific_item)
	else:
		if Inventory.search_item(Inventory.slot.item):
			return true
		if refresh:
			Inventory.save_dat.inventory.append(verific_item)
			Inventory.save_dat.equipped.erase(verific_item)

func add_button(item_save: int,slot,index: int) -> void: # Cria o botão do item especificado.
	var item = Inventory.search_item(item_save,"",equipped)
	var item_button = new_item_button.instance()
	item_button.item = item
	item.slot = index
	slot.add_child(item_button)
