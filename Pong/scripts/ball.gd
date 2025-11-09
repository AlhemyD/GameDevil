extends Node2D

@export var speed: float = 200.0
var velocity: Vector2 = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var angular_velocity: float = 0.0
@onready var window = get_window()

# Ссылка на спрайт для размера
@onready var ball_sprite = $BallSprite
@onready var size = ball_sprite.texture.get_size() if ball_sprite != null else Vector2(16,16)

# Ссылки на ракетки
@onready var paddle_left = get_node("/root/Main/PaddleLeft")
@onready var paddle_right = get_node("/root/Main/PaddleRight")

func _ready():
	rng.randomize()
	reset_ball()

func _process(delta: float) -> void:
	if global.game_ended:
		return
	var next_pos = global_position + velocity * delta
	rotation += angular_velocity * delta
	# верх/низ экрана
	if next_pos.y - size.y/2 < 0:
		next_pos.y = size.y/2
		velocity.y *= -1
	elif next_pos.y + size.y/2 > window.size.y:
		next_pos.y = window.size.y - size.y/2
		velocity.y *= -1

	# проверка столкновения с ракетками вручную
	for paddle in [paddle_left, paddle_right]:
		var paddle_shape = paddle.get_node("CollisionShape2D").shape
		var paddle_pos = paddle.global_position

		# проверяем пересечение AABB с учетом размера мяча
		if next_pos.x + size.x/2 > paddle_pos.x - paddle_shape.extents.x and \
		   next_pos.x - size.x/2 < paddle_pos.x + paddle_shape.extents.x and \
		   next_pos.y + size.y/2 > paddle_pos.y - paddle_shape.extents.y and \
		   next_pos.y - size.y/2 < paddle_pos.y + paddle_shape.extents.y:

			# отражаем мяч по X
			velocity.x *= -1
			var offset = (next_pos.y - paddle_pos.y) / paddle_shape.extents.y
			velocity.y = offset * speed
			velocity = velocity.normalized() * speed
			
			angular_velocity = rng.randf_range(-20, 20)
			
			# чтобы не застрял внутри ракетки
			if paddle == paddle_left:
				next_pos.x = paddle_pos.x + paddle_shape.extents.x + size.x/2
			else:
				next_pos.x = paddle_pos.x - paddle_shape.extents.x - size.x/2

	# левая и правая границы — сброс мяча
	if next_pos.x - size.x/2 < 0:
		global.count_right+=1
		reset_ball()
		return
	if next_pos.x + size.x/2 > window.size.x:
		global.count_left+=1
		reset_ball()
		return

	global_position = next_pos

func reset_ball():
	global_position = window.size / 2
	var dir_x = -1 if rng.randi_range(0, 1) == 0 else 1
	var dir_y = rng.randf_range(-0.5, 0.5)
	velocity = Vector2(dir_x, dir_y).normalized() * speed
	angular_velocity = rng.randf_range(-20, 20)
