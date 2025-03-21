extends CharacterBody2D

@export var speed = 400
@export var gravity_force = 30
@export var jump_force = -500

var max_fall_speed = 1500
var can_double_jump = true
var is_walljumping = false
var wall_slide_speed = 2000

@onready var jump_height_timer: Timer = $JumpHeightTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer
@onready var hook_cast: Node2D = $HookRayCast
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var hook = { "position": Vector2(), "is_hooked": false, "max_length": 500, "current_length": 0, "strength": 1}

func _ready() -> void:
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
		velocity *= hook.strength #Determine how hard the hook will pull player in
	queue_redraw()

func handle_animation() -> void:
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

func _physics_process(delta: float) -> void:
	handle_gravity()
	handle_movement(delta)
	handle_hook(delta)
	handle_animation()
	
	move_and_slide()


func _on_jump_height_timer_timeout() -> void:
	if !Input.is_action_pressed("jump"):
		if velocity.y < -100:
			velocity.y = -100


func _on_wall_jump_timer_timeout() -> void:
	is_walljumping = false
