extends CharacterBody2D

@export var speed: int = 400
@export var sprint_modifier: float = 1.5
@export var gravity_force: int = 30
@export var jump_force: int = -500
@export var camera_zoom_strength: float = 0.25

var max_fall_speed = 1500
var can_double_jump = true
var is_walljumping = false
var wall_slide_speed = 2000

@onready var jump_height_timer: Timer = $JumpHeightTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer
@onready var hook_cast: Node2D = $HookRayCast
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

@onready var hook = { "position": Vector2(), "is_hooked": false, "max_length": 500, "current_length": 0, "strength": 1}

func _ready() -> void:
	hook.max_length = hook_cast.hook_length
	hook.current_length = hook.max_length

func _draw() -> void:
	draw_hook()

func handle_gravity():
	if !is_on_floor() and velocity.y <= max_fall_speed:
		velocity.y += gravity_force

func handle_jump(direction) -> void:
	# Floor jump
	if is_on_floor():
		jump_height_timer.start()
		velocity.y = jump_force
		return;
	
	# Wall jump
	if is_on_wall_only():
		velocity.y = jump_force
		velocity.x = -direction * speed
		is_walljumping = true
		wall_jump_timer.start()
		return;
	
	# Mid air jump
	if can_double_jump:
		velocity.y = jump_force
		can_double_jump = false
		return;

func handle_movement(delta):
	# Handle left/right movement
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	if !is_walljumping:
		if Input.is_action_pressed("run"):
			velocity.x = speed * sprint_modifier * horizontal_direction
		else:
			velocity.x = speed * horizontal_direction
	
	# Wall sliding
	if is_on_wall_only():
		velocity.y = wall_slide_speed * delta
	
	# Handle jump
	if is_on_floor():
		can_double_jump = true

	if Input.is_action_just_pressed("jump"):
		handle_jump(horizontal_direction)

# Grappling Hook
func draw_hook(): 
	 # Hook radius
	if Input.is_action_pressed("grapple"):
		draw_circle(Vector2(0, 0), hook.max_length, Color.RED, false, 0.5, true)
	
	
	# What the pl
	if hook.is_hooked:
		draw_line(hook_cast.position, to_local(hook.position), Color.BURLYWOOD, 3, true) 
	else:
		return
	
	# Testing hook ray cast
	#var hook_collision_point = hook_cast.get_hook_position()
	#if hook_cast.is_colliding() and global_position.distance_to(hook_cast.get_hook_position()) < hook.max_length:
	#	draw_line(hook_cast.position, to_local(hook_collision_point), Color.WHITE, 0.5, true)

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
	
	if Input.is_action_just_released("grapple") and hook.is_hooked or !hook.position:
		hook.is_hooked = false
	
	if hook.is_hooked:
		handle_swing(delta)
		velocity *= hook.strength #Determine how hard the hook will pull player in
	queue_redraw()

func handle_animation() -> void:
	self.modulate = Color.WHITE
	if !can_double_jump:
		animation.modulate = Color.LIGHT_PINK
	else:
		animation.modulate = Color.WHITE
	
	if velocity.length() > 0:
		animation.animation = "walk"
		animation.play()
	else:
		animation.animation = "default"
		animation.stop()
	
	if velocity.x < 0:
		animation.flip_h = true
	else:
		animation.flip_h = false

func handle_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in"):
		camera.zoom += Vector2(camera_zoom_strength, camera_zoom_strength)
	if Input.is_action_just_pressed("zoom_out"):
		camera.zoom -= Vector2(camera_zoom_strength, camera_zoom_strength)

func _physics_process(delta: float) -> void:
	handle_gravity()
	handle_movement(delta)
	handle_hook(delta)
	handle_animation()
	handle_zoom()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene() #Reset the level
	
	move_and_slide()


func _on_jump_height_timer_timeout() -> void:
	if !Input.is_action_pressed("jump"):
		if velocity.y < -100:
			velocity.y = -100


func _on_wall_jump_timer_timeout() -> void:
	is_walljumping = false
