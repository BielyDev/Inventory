extends Node

class_name Support

enum SYSTEM_BUTTON {KEYBOARD,MOBILE,GAMEPAD}

var is_gamepad: bool = false
var use_cursor: bool = true
var is_mobile_system: bool = false
var system_button: int
var cursor_gamepad_speed : int = 800
var cursor_position: Vector2
var verific_cursor_position: Vector2
var mouse_position: Vector2
var sprite_cursor: Sprite
var grobus_all: Button

var gamepad_cursor: Texture = preload("res://addons/Inventory_Template/Assets/Icons/Gamepad/Cursor.tres")
var new_input_button: InputEventMouseButton = InputEventMouseButton.new()
var new_input_motion: InputEventMouseMotion = InputEventMouseMotion.new()


func _ready() -> void:
	is_mobile_system = "Android" or "iOS"

func _input(_event: InputEvent) -> void:
	_refresh_system_button(_event)
	
	if system_button == SYSTEM_BUTTON.MOBILE:
		_mobile(_event)
		_exit_gamepad()
	
	
	if _event is InputEventMouseMotion:
		mouse_position = _event.position
		
		match system_button:
			SYSTEM_BUTTON.GAMEPAD:
				if is_instance_valid(sprite_cursor):
					sprite_cursor.global_position = _event.position


func _process(_delta: float) -> void:
	match system_button:
		SYSTEM_BUTTON.KEYBOARD:
			cursor_position = get_viewport().get_mouse_position()
			_exit_gamepad()
		SYSTEM_BUTTON.GAMEPAD:
			_gamepad(_delta)


func _refresh_system_button(_event: InputEvent) -> void:
	#if is_gamepad_use:
	#	return
	
	if _event is InputEventKey:
		system_button = SYSTEM_BUTTON.KEYBOARD
	if _event is InputEventJoypadButton or _event is InputEventJoypadMotion:
		system_button = SYSTEM_BUTTON.GAMEPAD
	if _event is InputEventScreenTouch:
		if _event is InputEventJoypadButton or _event is InputEventJoypadMotion:
			return
		system_button = SYSTEM_BUTTON.MOBILE


func _mobile(_event: InputEvent) -> void:
	if _event is InputEventScreenTouch:
		
		if _event.pressed:
			mouse_position = get_viewport().get_mouse_position()
			
			new_input_button.pressed = true
			new_input_button.button_index = BUTTON_LEFT
			new_input_button.position = mouse_position
			
			Input.parse_input_event(new_input_button)
		
		if _event.pressed == false:
			mouse_position = get_viewport().get_mouse_position()
			
			new_input_button.pressed = false
			new_input_button.button_index = BUTTON_LEFT
			new_input_button.position = mouse_position
			
			Input.parse_input_event(new_input_button)
			
			new_input_motion.position = Vector2(-999,-999)
			Input.parse_input_event(new_input_motion)
	
	if _event is InputEventScreenDrag:
		mouse_position = get_viewport().get_mouse_position()
		new_input_motion.position = mouse_position
		
		Input.parse_input_event(new_input_motion)



func _gamepad(_delta: float) -> void:
	
	# Simulater cursor mouse:
	if is_gamepad == false:
		sprite_cursor = Sprite.new()
		grobus_all = Button.new()
		
		add_child(sprite_cursor)
		add_child(grobus_all)
		
		sprite_cursor.z_index = 200
		sprite_cursor.scale = Vector2(0.14,0.14)
		sprite_cursor.texture = gamepad_cursor
		
		grobus_all.hide()
		
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		is_gamepad = true
	
	
	if use_cursor: cursor_position += (Input.get_vector("ui_left","ui_right","ui_up","ui_down") * cursor_gamepad_speed) * _delta
	cursor_position.x = clamp(cursor_position.x,0,OS.window_size.x)
	cursor_position.y = clamp(cursor_position.y,0,OS.window_size.y)
	
	new_input_motion.position = cursor_position
	if verific_cursor_position != cursor_position:
		Input.parse_input_event(new_input_motion)
	
	verific_cursor_position = cursor_position
	
	_simulate_button("ui_accept",BUTTON_LEFT)
	_simulate_button("ui_cancel",BUTTON_RIGHT)


func _simulate_button(action: String,button_index: int) -> void:
	if Input.is_action_just_pressed(action):
		new_input_button.pressed = true
		new_input_button.button_index = button_index
		new_input_button.position = cursor_position
		
		Input.parse_input_event(new_input_button)
		
		animated_button(0.5,0.3)

	
	if Input.is_action_just_released(action):
		new_input_button.pressed = false
		new_input_button.button_index = button_index
		new_input_button.position = cursor_position
		
		Input.parse_input_event(new_input_button)
		
		yield(get_tree(),"idle_frame")
		
		grobus_all.grab_focus()
		animated_button(0,0.6)


func _exit_gamepad() -> void:
	if is_gamepad:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		sprite_cursor.queue_free()
		grobus_all.queue_free()
		is_gamepad = false


func animated_button(op: float,circ: float) -> void: 
	gamepad_cursor.gradient.offsets[0] = circ-0.1 #0.37
	gamepad_cursor.gradient.offsets[1] = circ # 0.47
	gamepad_cursor.gradient.offsets[2] = (circ + 0.12) - 0.1 # 0.581
	gamepad_cursor.gradient.offsets[3] = (circ + 0.2) - 0.1 # 0.651
	gamepad_cursor.gradient.colors[0] = Color(1, 1, 1, op)
