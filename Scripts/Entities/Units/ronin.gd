extends base_character

@export var damage_area              : Area2D
@export var damage_area_shape        : CircleShape2D

func _ready() -> void:
	super._ready()
	pass

func attack(target : Vector2):
	if target != global_position && my_state != STATES.DASH && can_dash_flag:
		flip_to_point(target)
		dash(global_position.direction_to(target))
	pass

func dash(target_direction = my_controller.get_move_target()):
	if target_direction.length() == 0 || my_state == STATES.DASH || !can_dash_flag:
		return
	
	var dash_power = my_parameters.dash_distance / my_parameters.dash_time
	velocity = target_direction * dash_power
	
	change_state(STATES.DASH)
	
	damage_area_shape.radius = my_parameters.damage_area_size
	set_area_masks(my_controller.get_bullet_collision_mask())
	
	var dash_tween = create_tween()
	dash_tween.tween_callback(clear_mask)
	dash_tween.tween_callback(clear_layers)
	dash_tween.tween_method(dash_move, 0, 0, my_parameters.dash_time)
#	dash_tween.tween_property(self, "global_position", target , my_parameters.dash_time)
#	dash_tween.tween_interval(my_parameters.dash_time)
	dash_tween.tween_callback(dash_end)
	dash_tween.play()
	
	can_dash_flag = false
	dash_timer.start(my_parameters.dash_cooldown)
	
	print_debug("dash cooldown", my_parameters.dash_cooldown)
	pass

func change_state(new_state : STATES):
	match new_state:
		STATES.RELOADING:
			reloading_flag = true
		STATES.MOVE:
			if my_state != STATES.MOVE:
				my_state = STATES.MOVE
				play_animation("move")
		STATES.IDLE:
			if my_state != STATES.IDLE:
				my_state = STATES.IDLE
				play_animation("idle")
		STATES.DASH:
			if my_state != STATES.DASH:
				my_state = STATES.DASH
				play_animation("attack")
		STATES.ATTACK:
#			if my_state != STATES.ATTACK:
#				my_state = STATES.ATTACK
			play_animation("attack")
	pass

func dash_end():
	clear_area_masks()
	super.dash_end()
	pass

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is base_character:
		body.hit(my_parameters.damage)
	pass # Replace with function body.

func set_area_masks(masks_dictionary : Dictionary):
	for layer in masks_dictionary.keys():
		damage_area.set_collision_mask_value(layer, masks_dictionary[layer])
	pass

func clear_area_masks():
	for layer in range(1, 6):
		damage_area.set_collision_mask_value(layer, false)
	pass
