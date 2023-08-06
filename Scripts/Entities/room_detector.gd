extends Area2D

@export var room_id : int
var activated := false

func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body is base_character:
		if !body.my_controller.is_enemy():
			activated = true
			get_tree().call_group("units", "activate", room_id)
	pass # Replace with function body.
