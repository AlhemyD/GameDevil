extends Control

func _ready():
	$PaddleType.add_item("Классическая")
	$PaddleType.add_item("ЛАВА-ЛАВА") 
	$PaddleType.add_item("Ретро")
	
	$PaddleType.selected = global.paddle_type

func _on_StartGame_pressed():
	global.paddle_type = $PaddleType.selected
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_difficulty_item_selected(index: int) -> void:
	global.difficulty = index

func _on_robot_toggled(toggled_on: bool) -> void:
	global.robot = toggled_on

func _on_PaddleType_item_selected(index: int) -> void:
	global.paddle_type = index
