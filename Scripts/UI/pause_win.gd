extends Control

@export var title_txt     : Label   
@export var music_txt     : Label   
@export var sound_txt     : Label   
@export var continue_txt  : Label      
@export var restart_txt   : Label     

@export var scroll        : Control
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("localization")
	localization()
	pass # Replace with function body.


func localization():
	title_txt.text = "PAUSE_TXT"
	music_txt.text = "MUSIC_TXT"
	sound_txt.text = "SOUND_TXT"
	continue_txt.text = "CONTINUE_TXT"
	restart_txt.text = "RESTART_GAME_TXT"
	pass


func update_level():
	scroll.update_level()
	pass

func _on_restart_pressed() -> void:
	WinHud.show_pause_win(false)
	WinHud.restart()
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	WinHud.show_pause_win(false)
#	queue_free()
	pass # Replace with function body.


func _on_restart_level_pressed() -> void:
	WinHud.show_pause_win(false)
	WinHud.restart_level()
	pass # Replace with function body.
