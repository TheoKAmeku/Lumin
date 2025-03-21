extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path: PathFollow2D = $PathFollow2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite_animation: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D

func _ready() -> void:
	sprite_animation.play()
	
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)

func _process(_delta: float) -> void:
	path.progress += speed
