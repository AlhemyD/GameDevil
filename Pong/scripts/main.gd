extends Node2D


@onready var count = $Count
@onready var winner = $Winner
@onready var ball = $Ball
@onready var left = $PaddleLeft
@onready var right = get_node("PaddleRight")

func _ready():
	count.text = str(global.count_left)+"-"+str(global.count_right)
	right.robot = global.robot
	if global.robot:
	
		if global.difficulty == 0:  # Лёгкий уровень
			ball.speed = 800
			right.speed/=3
			
		elif global.difficulty == 1:  # Средний уровень
			ball.speed = 700
			right.speed/=2
			
		else:  # Тяжёлый уровень
			ball.speed = 650
			right.speed/=1.5
			

func _process(_delta):
	if not global.game_ended:
		count.text = str(global.count_left)+"-"+str(global.count_right)
		if max(global.count_left, global.count_right) >= global.WINNING_SCORE:
			global.game_ended = true
			if global.count_left > global.count_right:
				winner.text="Left wins"
			elif global.count_left < global.count_right:
				winner.text="Right wins"
			else:
				winner.tet="Draw"
			winner.visible = true
			
	else:
		if Input.is_anything_pressed():
			global.count_left=0
			global.count_right=0
			winner.visible=false
			global.game_ended = false
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
