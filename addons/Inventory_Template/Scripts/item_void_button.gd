extends Control

onready var amount_text : Label = $z_index/item_button/amount
onready var button : Button = $z_index/item_button

func _process(_delta: float) -> void:
	rect_global_position = Inventory.support.mouse_position-(rect_size/2)
	refresh()

func _ready() -> void:
	var item_instance = load(Inventory.save_dat.item_no_slot.resource_path).instance()
	button.icon = item_instance.icon
	#VisualServer.canvas_item_set_z_index(self,2)

func refresh() -> void: # Verifica se o item ainda existe e a quantidade.
	if Inventory.save_dat.item_no_slot != null:
		amount_text.text = str(Inventory.save_dat.item_no_slot.amount)
		
		if Inventory.save_dat.item_no_slot.amount == 0:
			
			Inventory.save_dat.item_no_slot = null
			queue_free()
	
	else: queue_free()

func refresh_icon() -> void:
	var item_instance = load(Inventory.save_dat.item_no_slot.resource_path).instance()
	button.icon = item_instance.icon
