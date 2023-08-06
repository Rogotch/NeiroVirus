extends Resource
class_name unit_parameters

signal health_changed
signal ammo_changed
signal death

var name                   := ""
var max_health             := 10.0
var health                 := 10.0 : set = change_health
var speed                  := 500.0
var slide_value            := 0.05
var fire_rate              := 0.1
var ammo_max               := 10
var ammo                   := 10 : set = change_ammo
var reloading_time         := 2.0
var corruption_distance    := 200.0
var corruption_cooldown    := 15.0
var corruption_defence     := 1
var dash_distance          := 300.0
var dash_time              := 0.2
var dash_cooldown          := 30.0
var damage_area_size       := 30.0
var bullets_spread         := 0.01

var damage                 := 1.0
var bullett_lifetime       := 0.1
var bullet_speed           := 1000.0

func change_health(new_value : float):
	health = new_value
	health_changed.emit()
	check_death()
	pass

func change_ammo(new_value : int):
	ammo = new_value
	ammo_changed.emit()
	pass

func check_death():
	if health <= 0:
		death.emit()
	pass

func load_parameters(id : int):
	var unit_data : Dictionary = Database.get_obj_by_property_value_from_arr("id", id, Database.enemies)
	var data_keys = unit_data.keys()
	for key in data_keys:
		set_parameter(key, unit_data[key])
	pass

func set_parameter(parameter_name : String, value):
	match parameter_name:
		"bullets_spread" :
			bullets_spread      = value
		"health" :
			max_health          = value
			health              = value
		"speed" :
			speed               = value
		"damage" :
			damage              = value
		"bullett_lifetime" :
			bullett_lifetime    = value
		"bullet_speed" :
			bullet_speed        = value
		"damage_area_size" :
			damage_area_size    = value
		"slide_value" :
			slide_value         = value
		"fire_rate" :
			fire_rate           = value
		"ammo_max" :
			ammo                = value
			ammo_max            = value
		"reloading_time" :
			reloading_time      = value
		"corruption_distance" :
			corruption_distance = value
		"corruption_cooldown" :
			corruption_cooldown = value
		"corruption_defence" :
			corruption_defence  = value
		"dash_distance" :
			dash_distance       = value
		"dash_time" :
			dash_time           = value
		"dash_cooldown" :
			dash_cooldown       = value
	pass
