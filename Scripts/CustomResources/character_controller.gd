extends Resource
class_name character_controller

var controlled_object : base_character



func _init(character : base_character) -> void:
	controlled_object = character
	pass

func get_move_target():
	return Vector2.ZERO
	pass

func get_target():
	return Vector2.ZERO
	pass

func get_collision_layers():
	return {1 : true, 3 : false, 4: true}
	pass

func get_collision_mask():
	return {2 : true, 5: true}
	pass

func get_bullet_collision_mask():
	return {2 : true, 3: true}
	pass

func get_object_position() -> Vector2:
	return controlled_object.global_position
	pass

func is_enemy() -> bool:
	return true
	pass

func can_get_object_position() -> bool:
	var wr_contr = weakref(controlled_object)
	return false if !wr_contr.get_ref() else true
	pass

func detect_enemy():
	pass
