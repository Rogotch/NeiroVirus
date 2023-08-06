extends RigidBody2D
class_name base_bullet

var my_params := bullet_parameters.new(self)


func _ready() -> void:
	start_timeout()
	pass

func shoot_me(target : Vector2):
	var impulse_vector = global_position.direction_to(target) * my_params.bullet_speed
	var deviation_angle = PI * 0.05
	rotation -= deviation_angle
#	bullet.rotation += Global.rng.randf_range(-deviation_angle, deviation_angle)
	impulse_vector = impulse_vector.rotated(Global.rng.randf_range(-deviation_angle, deviation_angle))
#	apply_central_force(global_position.direction_to(target) * my_params.bullet_speed)
	apply_central_impulse(impulse_vector)
	pass

func start_timeout():
	var death_tween = create_tween()
	death_tween.tween_interval(my_params.lifetime)
	death_tween.tween_callback(death)
	death_tween.play()
	pass

func set_bullet_params(unit_params : unit_parameters):
	my_params.set_params(unit_params)
	pass

func _on_body_entered(body: Node) -> void:
	if body is base_character:
		body.hit(my_params.damage)
	death()
	pass # Replace with function body.

func death():
	queue_free()
	pass

func set_masks(masks_dictionary : Dictionary):
	for layer in masks_dictionary.keys():
		set_collision_mask_value(layer, masks_dictionary[layer])
	pass
