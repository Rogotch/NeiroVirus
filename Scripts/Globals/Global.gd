extends Node

var player
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	TranslationServer.set_locale("en")
#	demonstration = ProjectSettings.get_setting("global/demonstration")
	pass

static func deep_copy(v): #Функция для дублирования объектов вроде словарей
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
	pass

func delete_children(node):
	for child in node.get_children():
		child.queue_free()
	pass

func delete_children_control(node):
	for child in node.get_children():
		child.visible = false
		child.queue_free()
	pass

func rand_weight(weight_arr):
#	var weight_arr = {0 : 1, 1 : 1, 3 : 4}
	var full_weight = 0
	for i in weight_arr.values():
		full_weight += i
	rng.randomize()
	var result = rng.randi()%int(full_weight)
	var keys = weight_arr.keys()
	var summ = 0
	for i in keys.size():
		summ += weight_arr[keys[i]]
		if result < summ:
			return keys[i]
	
	pass

func is_weak(node) -> bool:
	var wr_contr = weakref(node)
	return !wr_contr.get_ref()
	pass

func get_direction(start, target):
	var direction = Vector2(target - start).normalized()
	direction = Vector2i(direction)
	return direction
	pass

func random_check(random_value : float):
#	randomize()
	var chance = randf() * 100.0
#	prints("dodge!", chance, random_value)
	return chance <= random_value
	pass

