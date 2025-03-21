extends Control

func _on_continue_playing_pressed() -> void:
	LevelSelect.visible = true
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
