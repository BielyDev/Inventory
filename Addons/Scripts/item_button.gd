extends Control

onready var amount_text : Label = $z_index/item_button/amount
onready var button : Button = $z_index/item_button

var item

func _ready() -> void:
	ready_button()
	refresh()
	
	Inventory.connect("add_item",self,"refresh")

func ready_button() -> void:
	var item_scene = Inventory.instantiate_item(item.path)
	
	button.icon = item_scene.icon
	button.hint_tooltip = str(
		"Name: ",item_scene.name_item,"\n",
		"Type: ",Inventory.TYPE.keys()[item_scene.type],
		"\n\n Description: \n"    ,item_scene.description
	)
	yield(get_tree().create_timer(0.01),"timeout")
	button.rect_size = rect_size

func refresh() -> void: # Verifica se o item ainda existe e a quantidade.
	var item_search = Inventory.search_item(item.id,"",get_parent().equipped)
	
	if item_search == null:
		queue_free()
	else:
		if item_search.amount == 0:
			queue_free()
	
	amount_text.text = str(item.amount)
