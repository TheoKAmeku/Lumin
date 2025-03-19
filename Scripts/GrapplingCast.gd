extends Node2D

@export var hook_length = 500

func is_colliding() -> bool:
	for raycast in get_children():
		if raycast is RayCast2D and raycast.is_colliding():
			return true
	return false

func get_hook_position():
	for raycast in get_children():
		if raycast.is_colliding():
			return raycast.get_collision_point()

func _ready() -> void:
	var current_pos = 0
	var current_angle = 0
	var is_negative = true
	
	for n in range(1):
		var raycast = RayCast2D.new()
		
		raycast.target_position = Vector2(hook_length, 0)
		
		is_negative = !is_negative
		var new_position = current_pos if is_negative else -current_pos
		var new_angle = -current_angle if is_negative else current_angle
		
		raycast.position = Vector2(new_position, 0)
		#raycast.rotation = new_angle
		raycast.rotate(new_angle)
		raycast.add_exception(self.get_parent())
		add_child(raycast)
		
		current_pos += 2
		current_angle += 5
