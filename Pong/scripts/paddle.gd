# scripts/Paddle.gd
extends StaticBody2D

@export var speed: float = 400.0
@export var up_action: String = "p1_up"
@export var down_action: String = "p1_down"

var top_limit: float
var bottom_limit: float

func _ready():
	if $CollisionShape2D.shape == null:
		print("CollisionShape2D.shape не задан!")
		return
	var half_height = $CollisionShape2D.shape.extents.y
	var rect = get_viewport_rect()
	top_limit = half_height + 4
	bottom_limit = rect.size.y - half_height - 4

func _process(delta):
	var dir = 0.0
	if Input.is_action_pressed(up_action):
		dir -= 1
	if Input.is_action_pressed(down_action):
		dir += 1

	position.y += dir * speed * delta
	position.y = clamp(position.y, top_limit, bottom_limit)
