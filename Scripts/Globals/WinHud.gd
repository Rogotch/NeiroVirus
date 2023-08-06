extends CanvasLayer

@export var hud_layer             : CanvasLayer
@export var ui_layer              : CanvasLayer
@export var wins_layer            : CanvasLayer
#@export var vfx_layer             : CanvasLayer
@export var pause_layer           : CanvasLayer
@export var tooltip               : Control

var pause_flag      := false
var last_pause_flag := false
var pause_win_flag  := false
var ui_flag         := false
var active_scene = null

var all_scenes = {
}
var all_wins = {
}

var ability_buttons = {}
var turn := 0
var music_index := 0

func _ready() -> void:
	pass # Replace with function body.

func set_ui_visibility(flag : bool):
#	hud_layer.visible = flag
	pass


func show_win(win_name):
	var new_win = load(all_wins[win_name]).instantiate()
	wins_layer.add_child(new_win)
	pass

func show_win_by_path(win_path):
	var new_win = load(win_path).instantiate()
	wins_layer.add_child(new_win)
	pass


func death():
	pause(true)
	show_win("death_win")
	set_ui_visibility(false)
	pass

func victory():
	pause(true)
	show_win("victory_win")
	set_ui_visibility(false)
	
	pass

func change_scene_by_key(scene_key :String):
	if active_scene != null:
		active_scene.queue_free()
	Loader.goto_scene(all_scenes[scene_key])
#	get_tree().change_scene(all_scenes[scene_key])
	pass

func change_scene_to_file(scene_path :String):
	if active_scene != null:
		active_scene.queue_free()
	Loader.goto_scene(scene_path)
#	get_tree().change_scene(all_scenes[scene_key])
	pass

func restart():
#	stop_music()
	set_ui_visibility(false)
	
	change_scene_by_key("start_win")
	pass


#func enemy_die():
#	var all_enemies = get_tree().get_nodes_in_group("enemies")
#	if all_enemies.size() == 0:
#		show_win("You_kill_all_enemies")
#	pass

func pause(flag):
	pause_flag = flag
	get_tree().paused = flag
#	_main_timer.paused = flag
	pass

func show_pause_win(flag):
#	pause_layer.update_level()
	pause_layer.visible = flag
	pause_win_flag = flag
	if          pause_flag &&  flag:
		last_pause_flag = true
		pause(flag)
	elif !(last_pause_flag && !flag):
		pause(flag)
#	_main_timer.paused = flag
	pass


func _input(event: InputEvent) -> void:
#	if Input.is_action_just_pressed("pause"):
#		if !ui_flag:
#			show_pause_win(!pause_win_flag)
	pass

func show_tooltip(target : Vector2, top_flag : bool, text : String, description : String):
	tooltip.set_text(text, description)
#	skill_tooltip.set_text.call_deferred(text, description)
#	skill_tooltip.set_minimum_size.call_deferred()
	tooltip.set_to_target.call_deferred(target, top_flag)
	tooltip.show.call_deferred()
	pass

#func show_skill_tooltip(target_node : Control, top_flag : bool, skill_id : int):
#	var skill_data = Database.get_obj_by_property_value_from_arr("id", skill_id, Database.abilities)
#	var skill_name        = tr(skill_data.loc_name_tag)
#	var skill_description = tr(skill_data.loc_descr_tag)
#	var dmg_value   = skill_data.damage       if skill_data.has("damage")       else 0
#	var cldwn_value = skill_data.cooldown     if skill_data.has("cooldown")     else 0
#	var min_d_value = skill_data.min_distance if skill_data.has("min_distance") else 0
#	var max_d_value = skill_data.max_distance if skill_data.has("max_distance") else 0
#
#	skill_description = skill_description.format({"dmg": dmg_value, "cooldown": cldwn_value, "min_dist": min_d_value, "max_dist": max_d_value})
#
#	var final_point = Vector2.ZERO
#	final_point.x = target_node.global_position.x + target_node.size.x / 2
#	final_point.y = target_node.global_position.y - (target_node.size.y if !top_flag else -20 - target_node.size.y)
#
#	show_tooltip(final_point, top_flag, skill_name, skill_description)
#
#	pass
#
#func show_perk_tooltip(target_node : Control, top_flag : bool, perk_data : passive_effect):
#	var perk_name        = tr(perk_data.name)
#	var perk_description = tr(perk_data.description)
#	var final_point = Vector2.ZERO
#	final_point.x = target_node.global_position.x + target_node.size.x / 2
#	final_point.y = target_node.global_position.y - (target_node.size.y if !top_flag else -20 - target_node.size.y)
#
#	show_tooltip(final_point, top_flag, perk_name, perk_description)
#
#	pass

func hide_tooltip():
	tooltip.visible = false
	pass
