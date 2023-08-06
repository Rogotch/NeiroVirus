extends Resource
class_name bullet_parameters

var lifetime           := 0.3
var bullets_spread     := 0.01
var damage             := 1
var bullet_speed       := 1000.0
var damage_area_size   := 1000.0

var controlled_object : base_bullet

func _init(bullet : base_bullet) -> void:
	controlled_object = bullet
	pass

func set_params(unit_params : unit_parameters):
	lifetime         = unit_params.bullett_lifetime
	bullet_speed     = unit_params.bullet_speed
	damage           = unit_params.damage
	damage_area_size = unit_params.damage_area_size
	pass
