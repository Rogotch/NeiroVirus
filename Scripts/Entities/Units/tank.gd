extends base_character

func _ready() -> void:
	super._ready()
	pass

func attack(target : Vector2):
	if can_shoot_flag && my_parameters.ammo > 0 && my_state != STATES.RELOADING:
		can_shoot_flag = false
		my_parameters.ammo -= 1
		flip_to_point(target)
		change_state(STATES.ATTACK)
		
		var bullet = GameObjects.rocket_class.instantiate()
		bullet.set_masks(my_controller.get_bullet_collision_mask())
		bullet = bullet as RigidBody2D
		bullet.set_bullet_params(my_parameters)
		get_parent().add_child(bullet)
		bullet.global_position = bullet_point.global_position
		bullet.look_at(target)
		bullet.shoot_me(target)
		
		firing_rate_timer.start(my_parameters.fire_rate)
	elif my_parameters.ammo == 0 && !reloading_flag:
		reload_start()
	pass
