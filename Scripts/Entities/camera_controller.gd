extends Camera2D

@export var RANDOM_SHAKE_STRENGTH := 30.0
@export var SHAKE_DECAY_RATE      :=  5.0
@export var NOISE_SHAKE_SPEED     := 30.0
@export var NOISE_SHAKE_STENGTH   := 60.0

var selected_character = null

var noise = FastNoiseLite.new()

var radius = 160

var offset_shake  := Vector2.ZERO
var offset_target := Vector2.ZERO

var shake_strength := 0.0
var noise_i := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	current = true
	add_to_group("camera")
	
#	noise.period = 2
	SignalsBus.connect("shake", Callable(self, "applay_shake"))
	
#	if zoom_on_start:
#		set_zoom_on_start()
	pass # Replace with function body.

func applay_shake():
	shake_strength = RANDOM_SHAKE_STRENGTH
	pass

#func set_zoom_on_start():
#	smooth_zoom(final_zoom)
#	pass

func _process(delta):
#	prints(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	if Global.player != null:
		if Global.player.can_get_object_position():
			global_position = lerp(global_position, Global.player.get_object_position(), 1)
	shake_strength = lerp(int(shake_strength), int(0), SHAKE_DECAY_RATE * delta)
	offset_shake = get_noise_offset(delta)
	
	offset = lerp(offset, offset_target + offset_shake, 0.05)
	pass

func get_noise_offset(delta : float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(
		0,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
	pass

func get_random_offset():
	return Vector2(
		Global.rng.randf_range(-shake_strength, shake_strength),
		Global.rng.randf_range(-shake_strength, shake_strength)
	)
	pass

func to_character(new_selected_character : Node2D):
	selected_character = new_selected_character
	pass
