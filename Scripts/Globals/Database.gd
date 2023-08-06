extends Node

signal resources_loaded

@export_file("*.json") var JSON_enemies
var enemies  = {}


func _ready():
	enemies = loadDB(JSON_enemies)
	emit_signal.call_deferred("resources_loaded")
	pass

func loadDB(path):
	var uploadedData = {}
	var data_file = FileAccess.open(path, FileAccess.READ)
	
	if FileAccess.get_open_error() != OK:
		prints("Error open file", path)
		return
		
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.new()
	var data = data_parse.parse_string(data_text)
#	data_parse.parse_string(data_text)
	
	if data_parse.get_error_line() != 0:
		prints("Error parse at line", data_parse.get_error_line())
		return
		
	uploadedData = data
	
	return uploadedData
	pass


#func loadTSV(path):
#	var uploadedData = {}
#	var data_file = File.new()
#
#	if data_file.open(path, File.READ) != OK:
#		prints("Error open file", path)
#		return
#
#	var data_arr = []
#
#	var line = data_file.get_line()
#	while (line.length() > 0):
#		data_arr.append(line)
#		line = data_file.get_line()
#	return data_arr
#	pass

func get_obj_by_property_value_from_arr(property_name, value, arr):
	for obj in arr:
		if obj.has(property_name):
			if obj[property_name] == value:
				return Global.deep_copy(obj)
	print_debug("I can't found value {val} or property {prop}".format({"val" : value, "prop" : property_name}))
	pass

func get_arr_by_property_value_from_arr(property_name, value, arr) -> Array:
	var final_arr = []
	for obj in arr:
		if obj.has(property_name):
			if obj[property_name] == value:
				final_arr.append(Global.deep_copy(obj))
	if final_arr.size() != 0:
		return final_arr
	else:
		print_debug("I can't found value {val} or property {prop}".format({"val" : value, "prop" : property_name}))
		return []
	pass
