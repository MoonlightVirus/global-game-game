extends Container



func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/main.tscn")



func _on_quit_pressed():
	get_tree().quit()
