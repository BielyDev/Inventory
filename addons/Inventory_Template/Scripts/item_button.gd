extends Control

onready var amount_text : Label = $z_index/item_button/amount
onready var button : Button = $z_index/item_button

var item # Item salvo no item_button(a cena em questão).
var mouse: bool = false # Caso já precise ser instanciado na posição do mouse.


func _ready() -> void:
	ready_button()
	refresh()
	
	Inventory.connect("refresh_data",self,"refresh")


func ready_button() -> void:
	var item_scene = load(item.resource_path).instance()
	
	call_deferred("add_child",item_scene)
	call_deferred("personalize_button",item_scene)


func personalize_button(item_scene ) -> void:
	var type_str: String = str(Inventory.TYPE.keys()[item_scene.type]).to_lower().capitalize()
	
	button.icon = item_scene.icon
	button.hint_tooltip = str(
		"Name: ",item_scene.name_item,"\n",
		"Type: ",type_str,"\n",
		"Amount: ",item.amount,"\n\n",
		"Description: \n  ",item_scene.description
	)
	
	item_scene.queue_free()


func refresh() -> void: # Verifica se o item ainda existe e a quantidade.
	var item_search = Inventory.search_item(item.id,"",get_parent().equipped)
	
	if item_search == null:
		get_parent().slot_item_id = -1
		queue_free()
	else:
		if item_search.amount == 0:
			erase(item_search)
			get_parent().slot_item_id = -1
			queue_free()
	
	get_parent().slot_item_id = item.id
	amount_text.text = str(item.amount)


func erase(item) -> void:
	if get_parent().equipped:
		Inventory.save_dat.equipped.erase(item)
	else:
		Inventory.save_dat.inventory.erase(item)


func _on_item_button_draw() -> void:
	button.rect_size = rect_size

