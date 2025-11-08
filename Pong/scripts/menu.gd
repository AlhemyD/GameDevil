extends Control

func _on_StartGame_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_Quit_pressed():
	get_tree().quit()


func _on_difficulty_item_selected(index: int) -> void:
	global.difficulty = index


func _on_robot_toggled(toggled_on: bool) -> void:
	global.robot = toggled_on
