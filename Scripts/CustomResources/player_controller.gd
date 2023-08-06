extends character_controller
class_name player_controller

func _init(character : base_character) -> void:
	super._init(character)
	InputListener.left_mouse_button.connect(try_attack)
	InputListener.right_mouse_button.connect(targeting_for_corruption)
	InputListener.reloading.connect(reload)
	InputListener.rmb_up.connect(hide_line)
	InputListener.dash.connect(dash)
	pass

func get_move_target():
	return InputListener.target_direction
	pass

func get_target():
	return InputListener.gl_mouse_position
	pass

func try_attack(target : Vector2):
	if !InputListener.rmb_pressed:
		controlled_object.attack(target)
	else:
		controlled_object.try_corrupt()
	pass

func targeting_for_corruption(target : Vector2):
	controlled_object.targeting_for_corruption(target)
	pass

func reload():
	if !controlled_object.reloading_flag:
		controlled_object.reload_start()
	pass

func hide_line():
	controlled_object.show_raycast_flag = false
	controlled_object.queue_redraw()
	pass

func dash():
	if controlled_object.my_state != base_character.STATES.DASH && controlled_object.can_dash_flag:
		controlled_object.dash()
	pass

func get_collision_layers():
	return {1 : true, 3 : true, 4: false}
	pass

func get_bullet_collision_mask():
	return {2 : true, 4: true}
	pass

func is_enemy() -> bool:
	return false
	pass
