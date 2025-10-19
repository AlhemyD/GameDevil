extends Node2D

var angular_velocity: float = 1.0
var velocity: Vector2i = Vector2i(0, 0)
var rng = RandomNumberGenerator.new()
@onready var window=get_window()
@onready var size = get_node("BallSprite").texture.get_size()

@export var speed = 80

func _ready() -> void:
	velocity = Vector2i(speed,speed)
	angular_velocity=rng.randf_range(1, 5)

func _process(delta: float) -> void:
	global_position+=velocity*delta
	rotation+=angular_velocity*delta
	
	if global_position.x > window.size.x-size.x/2:
		velocity.x*=-1
	elif global_position.y>window.size.y-size.y/2:
		velocity.y*=-1
	elif global_position.x <size.x/2:
		velocity.x*=-1
	elif global_position.y<size.y/2:
		velocity.y*=-1
