extends Control

onready var amount_text : Label = $z_index/item_button/amount
onready var button : Button = $z_index/item_button
var item


func _ready() -> void:
	var item_instance = load(item.path).instance()
	button.icon = item_instance.icon
	refresh()
	Autoload.connect("add_item",self,"refresh")

func refresh() -> void: # Verifica se o item ainda existe e a quantidade.
	var item_search = Autoload.search_item(item.id,"",get_parent().equipped)
	if item_search == null:
		queue_free()
	else:
		if item_search.amount == 0:
			queue_free()
	amount_text.text = str(item.amount)
