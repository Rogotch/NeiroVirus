extends base_bullet
@export var damage_area       : Area2D 
@export var damage_area_shape : CollisionShape2D 

func shoot_me(target : Vector2):
#	apply_central_force(global_position.direction_to(target) * my_params.bullet_speed)
	apply_central_impulse(global_position.direction_to(target) * my_params.bullet_speed / 10)
	constant_force = global_position.direction_to(target) * my_params.bullet_speed * 10
#	apply_central_impulse(global_position.direction_to(target) * my_params.bullet_speed)
	pass

func set_bullet_params(unit_params : unit_parameters):
	super.set_bullet_params(unit_params)
	var new_shape = CircleShape2D.new()
	damage_area_shape.shape = new_shape
	new_shape.radius = my_params.damage_area_size
	print("rocket_damage_size", my_params.damage_area_size)
	pass

func set_masks(masks_dictionary : Dictionary):
	for layer in masks_dictionary.keys():
		set_collision_mask_value(layer, masks_dictionary[layer])
		damage_area.set_collision_mask_value(layer, masks_dictionary[layer])
	pass

func _on_body_entered(body: Node) -> void:
	death()
	pass

func death():
	var all_bodies = damage_area.get_overlapping_bodies()
	print("all_bodies", all_bodies)
	
	for body in all_bodies:
		if body.has_method("hit"):
			body.hit(my_params.damage)
	
	super.death()
	pass
