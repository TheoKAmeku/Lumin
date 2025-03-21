extends Control

@export var levels_unlocked = [false, false, false, false]
@onready var unlock_message: Label = $UnlockMessage
@onready var unlock_timer: Timer = $UnlockMessage/Timer

func present_locked_message(locked_level: int, unlock_from_level: int) -> void:
	var locked_message_format = "Level %s is locked. Unlock it from level %s"
	var message = locked_message_format % [locked_level, unlock_from_level]
	
	unlock_message.text = message
	unlock_message.visible = true
	unlock_timer.start()

func _on_level_button_1_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file("res://Scenes/Worlds/world_1.tscn")

func _on_level_button_2_pressed() -> void:
	if !levels_unlocked[0]:
		present_locked_message(2, 1)
		return;

	visible = false
	get_tree().change_scene_to_file("res://Scenes/Worlds/world_2.tscn")

func _on_level_button_3_pressed() -> void:
	if !levels_unlocked[1]:
		present_locked_message(3, 2)
		return;

	visible = false
	get_tree().change_scene_to_file("res://Scenes/Worlds/world_3.tscn")

func _on_level_button_4_pressed() -> void:
	if !levels_unlocked[2]:
		present_locked_message(4, 3)
		return;

	visible = false
	get_tree().change_scene_to_file("res://Scenes/Worlds/world_4.tscn")

func _on_timer_timeout() -> void:
	unlock_message.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
