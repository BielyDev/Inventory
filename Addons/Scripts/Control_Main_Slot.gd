extends Control

export(int,"inventory","equip") var Mode

var new_item_button : PackedScene = preload("res://Addons/Scenes/item_button.tscn")

func _ready() -> void:
	refresh()
	
	Inventory.connect("add_item",self,"refresh") # Toda vez que um item for adicionado irar chamar o refresh()

var item_button
func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		if Inventory.save_dat.item_void == null:
			item_moviment()

func item_moviment() -> void: # Movimentar o item com o mouse.
	if is_instance_valid(Inventory.slot.node) and Inventory.slot.node.get_children().size() >= 1:
		item_button = Inventory.slot.node
		
		item_button.get_child(0).rect_global_position = get_global_mouse_position()-item_button.rect_size/2
		item_button.get_child(0).get_child(0).z_index = 1
	
	if item_button != Inventory.slot.node:
		if is_instance_valid(item_button) and item_button.get_child_count() >= 1:
			item_button.get_child(0).get_child(0).z_index = 0
			item_button.get_child(0).rect_position = Vector2(10,10)
			
			Inventory.slot = {node = null,item = -1}

func refresh() -> void: # Apaga todos os itens da interface e adiciona novamente.
	for child in get_children(): #Apaga
		for childs in child.get_children():
			childs.queue_free()
	
	if Mode == 0:
		for itens in Inventory.save_dat.inventory: #Adiciona
			create_buttons(itens)
	if Mode == 1:
		for itens in Inventory.save_dat.equipped: #Adiciona
			create_buttons(itens)

func create_buttons(itens) -> void:
	var item_button_ = new_item_button.instance()
	item_button_.item = itens
	
	if itens.slot != -1:
		get_child(itens.slot).item_id = itens.id
		get_child(itens.slot).add_child(item_button_)
