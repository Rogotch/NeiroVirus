extends Control
@export var content     : MarginContainer
@export var title_text  : Label
@export var full_text   : RichTextLabel

func set_minimum_size():
	size = content.get_minimum_size()
	size = content.get_combined_minimum_size()
	pass

func set_in_screen_position():
	var tooltip_global_rect = get_global_rect()
	
	if DisplayServer.screen_get_size().x < tooltip_global_rect.end.x:
		global_position.x -= tooltip_global_rect.end.x - DisplayServer.screen_get_size().x - 20
	elif tooltip_global_rect.position.x < 0:
		global_position.x = 20
	
	if DisplayServer.screen_get_size().y < tooltip_global_rect.end.y:
		global_position.y -= tooltip_global_rect.end.y - DisplayServer.screen_get_size().y - 20
	elif tooltip_global_rect.position.y < 0:
		global_position.y = 20
	
#	print_debug(global_position)
	pass 

func set_to_target(target : Vector2, top_flag : bool):
	var x_offset = -size.x/2
	var y_offset = 0 if top_flag else -size.y
	
	global_position = target + Vector2(x_offset, y_offset)
#	print_debug(global_position)
	set_in_screen_position.call_deferred()
	pass

func set_text(title : String, text : String):
	title_text.text = title
	full_text.text  = text
#	print_debug("start"+text+"end")
	set_minimum_size()
	pass
