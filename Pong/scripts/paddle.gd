extends StaticBody2D

@export var speed: float = 400.0
@export var up_action: String = "p1_up"
@export var down_action: String = "p1_down"
@export var robot: bool = false

@onready var ball = get_parent().get_node("Ball")
@onready var sprite = $Sprite2D 

var top_limit: float
var bottom_limit: float

func _ready():
	if $CollisionShape2D.shape == null:
		return
	
	apply_paddle_style()
	
	var half_height = $CollisionShape2D.shape.extents.y
	var rect = get_viewport_rect()
	top_limit = half_height + 4
	bottom_limit = rect.size.y - half_height - 4

func apply_paddle_style():
	speed = 400.0
	
	var texture: Texture2D
	var texture_path: String
	
	match global.paddle_type:
		0:
			texture_path = "res://assets/paddle_classic.png"
		1:
			texture_path = "res://assets/paddle_modern.png"
		2:
			texture_path = "res://assets/paddle_retro.png"
	
	if FileAccess.file_exists(texture_path):
		texture = load(texture_path)
	
	if sprite and texture:
		sprite.texture = texture
		
		var texture_size = texture.get_size()
		if texture_size != Vector2.ZERO:
			$CollisionShape2D.shape.extents = texture_size / 2
			sprite.scale = Vector2.ONE
		
		var half_height = $CollisionShape2D.shape.extents.y
		var rect = get_viewport_rect()
		top_limit = half_height + 4
		bottom_limit = rect.size.y - half_height - 4

func _process(delta: float) -> void:
	if global.game_ended:
		return
	if not robot:
		var dir = 0.0
		if Input.is_action_pressed(up_action):
			dir -= 1
		if Input.is_action_pressed(down_action):
			dir += 1

		position.y += dir * speed * delta
		position.y = clamp(position.y, top_limit, bottom_limit)
	else:
		if ball.position.y > position.y:
			position.y += speed * delta
		elif ball.position.y < position.y:
			position.y -= speed * delta
