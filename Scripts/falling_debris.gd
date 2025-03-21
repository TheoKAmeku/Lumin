extends Node2D

@export var gravity: float = 3  # Pixels per second squared
@export var max_fall_speed: float = 15  # Initial fall speed
@export var min_x: float = -800  # Spawn area minimum X
@export var max_x: float = 800  # Spawn area maximum X
@export var min_rotation: float = -90  # Spawn area minimum X
@export var max_rotation: float = 90  # Spawn area maximum X
@export var start_y: float = -550  # Start position (above screen)
@export var min_spawn_delay: float = 0.5  # Min delay between spawns (seconds)
@export var max_spawn_delay: float = 3.0  # Max delay between spawns (seconds)
var animation: AnimatedSprite2D

@onready var textures: Array[Sprite2D]  # Assign multiple textures in the editor

var sprite_count: int = 5
var sprites = []

func _ready():
	for texture in get_children():
		if texture is not Sprite2D:
			continue
		
		
		sprites.append(texture)
		#add_child(texture)
		for i in range(sprite_count - 1):
			var sprite = Sprite2D.new()
			sprite.apply_scale(Vector2(0.3, 0.3))
			
			sprite.texture = texture.texture
			sprite.position = Vector2(randi_range(min_x, max_x), start_y)
			sprites.append(sprite)
			add_child(sprite)

func _process(_delta):
	for sprite in sprites:
		sprite.position.y += randi_range(gravity, max_fall_speed)
		sprite.rotation_degrees += randi_range(min_rotation, max_rotation)

		# Reset when offscreen
		if sprite.position.y > get_viewport_rect().size.y + 50:
			sprite.position.y = start_y
			sprite.position.x = randi_range(min_x, max_x)
