extends Node2D

signal left_mouse_button( target : Vector2)
signal right_mouse_button(target : Vector2)
signal rmb_up
signal reloading
signal dash

var target_direction  : Vector2
var gl_mouse_position : Vector2

var lmb_pressed := false
var rmb_pressed := false

func _physics_process(delta: float) -> void:
	gl_mouse_position = get_global_mouse_position()
	if lmb_pressed:
		left_mouse_button.emit(gl_mouse_position)
	if rmb_pressed:
		right_mouse_button.emit(gl_mouse_position)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		target_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		target_direction = target_direction.normalized()
		if Input.is_action_just_pressed("reload"):
			reloading.emit()
		if Input.is_action_just_pressed("dash"):
			dash.emit()
	elif event is InputEventMouseButton:
		var pressed_flag = event.is_pressed()
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				lmb_pressed = pressed_flag
			MOUSE_BUTTON_RIGHT:
				rmb_pressed = pressed_flag
				if pressed_flag:
					pass
				else:
					rmb_up.emit()
	pass
