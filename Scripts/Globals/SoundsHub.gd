extends Node

var sounds_nodes = {
}

var music_nodes = {
}

func play_sound(sound_name):
	var sound_node = get_node(sounds_nodes[sound_name])
	sound_node.stop()
	sound_node.call_deferred("play")
	pass

func play_music(music_name):
	for music_key in music_nodes.keys():
		var actual_key = music_key
		var music_node = get_node(music_nodes[music_key])
		if music_name == music_key:
			music_node.play()
		else:
			music_node.stop()
	pass

func stop_music():
	for music_key in music_nodes.keys():
#		var actual_key = music_key
		var music_node = get_node(music_nodes[music_key])
		music_node.stop()
	pass

#func play_music_by_index():
#	if music.get_child_count() <= music_index:
#		music_index = 0
#	music.get_child(music_index).play()
#	pass
#
#func end_music():
#	music_index += 1
#	play_music_by_index()
#	pass
