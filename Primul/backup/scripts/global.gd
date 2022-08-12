extends Node


signal instance_player(id)
signal toggle_network_setup(toggle)

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
