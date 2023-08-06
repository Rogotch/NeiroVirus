extends character_controller
class_name  enemy_controller

func get_move_target():
	return controlled_object.global_position.direction_to(controlled_object.navigation_agent.get_next_path_position())
	pass

func get_target():
	var wr_contr = weakref(Global.player)
	if !wr_contr.get_ref():
		return get_object_position()
	return Global.player.get_object_position() if Global.player != null else get_object_position()
	pass

func detect_enemy():
	controlled_object.targeting_for_corruption(get_target())
	controlled_object.try_attack()
	
	pass
