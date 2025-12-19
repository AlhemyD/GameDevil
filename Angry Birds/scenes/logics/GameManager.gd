extends Node

enum GameState {
	Start,
	Play,
	Win,
	Lose
}

var CurrentGameState = GameState.Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match CurrentGameState:
		GameState.Start:
			pass
		GameState.Play:
			var projectiles = get_tree().get_nodes_in_group("Projectile")
			var enemies = get_tree().get_nodes_in_group("Enemy")
			if enemies.size() <= 0:
				CurrentGameState = GameState.Win
			elif projectiles.size() <= 0:
				CurrentGameState = GameState.Lose
		
		GameState.Win:
			print("You won!")
		GameState.Lose:
			print("You lose!")
