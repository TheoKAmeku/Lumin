extends Control

@export var levels_unlocked = [false, false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func present_locked_message() -> void:
	pass

func _on_level_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")

func _on_level_button_2_pressed() -> void:
	if !levels_unlocked[0]:
		present_locked_message()
		return;

	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")

func _on_level_button_3_pressed() -> void:
	if !levels_unlocked[1]:
		present_locked_message()
		return;

	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")

func _on_level_button_4_pressed() -> void:
	if !levels_unlocked[2]:
		present_locked_message()
		return;

	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")

func _on_level_button_5_pressed() -> void:
	if !levels_unlocked[3]:
		present_locked_message()
		return;

	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")
