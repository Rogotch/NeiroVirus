extends CanvasLayer

@export var progress_node : ProgressBar

var selected_path : String
var loader : ResourceLoader
var progress = []
var scene_load_status := 0

func _ready():
	set_process(false)
	pass

func goto_scene(path): # Game requests to switch to this scene.
	visible = true
	
	var error = ResourceLoader.load_threaded_request(path)
	if error != OK: # Check for errors.
		show_error()
		return
	selected_path = path
	set_process(true)
	
	# Start your "loading..." animation.
#	get_node("animation").play("loading")
	pass

func _process(time):
	# selected_path - путь загружаемой сцены
	# progress - прогресс загрузки
	# scene_load_status - прогресс загрузки
	scene_load_status = ResourceLoader.load_threaded_get_status(selected_path, progress)
	progress_node.value = progress[0] * 100
	
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		set_new_scene()
	pass

func set_new_scene():
	visible = false
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(selected_path))
	pass

func show_error():
	prints("error loading!")
	pass
