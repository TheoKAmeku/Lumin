extends CharacterBody2D

@export var speed = 300
@export var gravity_force = 30
@export var jump_force = 300

#Grappling hook
@onready var hook_cast: Node2D = $HookRayCast
@export var hook = { "position": Vector2(), "is_hooked": false, "max_length": 500, "current_length": 0, "swing_speed": 1}

func _ready() -> void:
	hook.current_length = hook.max_length

func _draw() -> void:
	draw_hook()

func handle_gravity():
	if !is_on_floor():
		velocity.y += gravity_force

func handle_movement():
	# Handle left/right movement
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	
	# Handle jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force

# Grappling Hook
func draw_hook():
	if hook.is_hooked:
		draw_line(hook_cast.position, to_local(hook.position), Color.AQUA, 3, true)
	else:
		return
	
	var hook_collision_point = hook_cast.get_hook_position()
	if hook_cast.is_colliding() and global_position.distance_to(hook_cast.get_hook_position()) < hook.max_length:
		draw_line(hook_cast.position, to_local(hook_collision_point), Color.WHITE, 0.5, true)

func handle_swing(delta):
	var radius = global_position - hook.position
	if velocity.length() < 0.01 or radius.length() < 10: 
		return
	
	var angle = acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	
	velocity += radius.normalized() * -rad_vel
	
	if global_position.distance_to(hook.position) > hook.current_length:
		global_position = hook.position + radius.normalized() * hook.current_length
	
	velocity += (hook.position - global_position).normalized() * 15000 *delta

func handle_hook(delta: float):
	hook_cast.look_at(get_global_mouse_position()) #Turn hook towards mouse
	
	
	
	if Input.is_action_just_pressed("grapple"):
		hook.position = hook_cast.get_hook_position()
		
		if hook.position:
			hook.is_hooked = true
			hook.current_length = global_position.distance_to(hook.position)
	
	if Input.is_action_just_released("grapple") and hook.is_hooked:
		hook.is_hooked = false
	
	if hook.is_hooked:
		handle_swing(delta)
		velocity *= hook.swing_speed #Determine swing speed
	
	queue_redraw()

func _physics_process(delta: float) -> void:
	handle_gravity()
	handle_movement()
	handle_hook(delta)
	
	move_and_slide()
