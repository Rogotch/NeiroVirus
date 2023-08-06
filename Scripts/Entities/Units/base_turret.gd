extends base_character
class_name base_turret
@export var weapon_sprite   : Sprite2D

func flip(flag : bool):
	pass

func _physics_process(delta: float) -> void:
	var states_flag =  my_state == STATES.DASH || my_state == STATES.ATTACK
	var on_point_flag = my_controller != null && my_controller.is_enemy() && navigation_agent.is_navigation_finished()
	var wait_in_room_flag = !player_flag && !active_flag
#	prints(wait_in_room_flag, !player_flag, active_flag)
	if my_controller == null || states_flag || on_point_flag || wait_in_room_flag:
		change_state(STATES.IDLE)
		return
	corruption_bar.value = my_parameters.corruption_cooldown - corruption_timer.time_left
	
	var target = my_controller.get_target()
	weapon_sprite.look_at(target)
	my_controller.detect_enemy()
	pass

func dash(target_direction = my_controller.get_move_target()):
	pass
