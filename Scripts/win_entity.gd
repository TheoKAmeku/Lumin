extends Node2D

@export var level_to_unlock = 0

func finish_level(level_to_unlock: int) -> void:
	LevelSelect.levels_unlocked[level_to_unlock - 2] = true
	
	LevelSelect.visible = true
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")

func win_screen() -> void:
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")

func _on_body_entered(_body: Node2D) -> void:
	if level_to_unlock == -1:
		win_screen()
	else:
		finish_level(level_to_unlock)
