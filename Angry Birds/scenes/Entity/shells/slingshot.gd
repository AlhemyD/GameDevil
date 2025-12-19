extends Node2D

enum SlingState{
	idle,
	pulling,
	projectileThrown,
	reset
}

var SlingShotState
@onready var right_line: Line2D = $RightLine
@onready var left_line: Line2D = $LeftLine
@onready var center_of_sling_shot: Vector2 = $CenterOfSlingShot.position

@export var maximum_pull = 100
@export var shot_reduction = 5

var tween: Tween

var projectile: RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SlingShotState = SlingState.idle
	left_line.points[1] = center_of_sling_shot
	right_line.points[1] = center_of_sling_shot
	
	projectile = get_tree().get_nodes_in_group("Projectile")[0]
	projectile.position = position + center_of_sling_shot
	#tween = get_tree().create_tween()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match SlingShotState:
		SlingState.idle:
			pass
		SlingState.pulling:
			if Input.is_action_pressed("LeftMouse"):
				var mousepos = get_global_mouse_position()-position
				if mousepos.distance_to(center_of_sling_shot) > maximum_pull:
					mousepos = (mousepos - center_of_sling_shot).normalized() * maximum_pull + center_of_sling_shot
				
				var velocity = center_of_sling_shot - mousepos
				var distance = mousepos.distance_to(center_of_sling_shot)
				projectile.position = mousepos+position
				left_line.points[1] = mousepos
				right_line.points[1] = mousepos
			else:
				var location = get_global_mouse_position()-position
				var distance = location.distance_to(center_of_sling_shot)
				
				if distance > maximum_pull:
					location = (location - center_of_sling_shot).normalized() * maximum_pull + center_of_sling_shot
					distance = location.distance_to(center_of_sling_shot)
				
				var velocity = center_of_sling_shot - location
				projectile.ThrowProjectile()
				projectile.apply_impulse(velocity/shot_reduction*distance)
				SlingShotState = SlingState.projectileThrown
				left_line.points[1] = center_of_sling_shot
				right_line.points[1] = center_of_sling_shot
				GameManager.CurrentGameState = GameManager.GameState.Play
				
				var camera = get_tree().get_nodes_in_group("Camera")[0]
				camera.followingProjectile = true
				
		SlingState.projectileThrown:
			pass
		SlingState.reset:
			var projectiles = get_tree().get_nodes_in_group("Projectile")
			if projectiles.size() > 0:
				projectile = projectiles[0] as RigidBody2D
				tween = get_tree().create_tween()
				tween.tween_property(
					projectile,
					"position",
					global_position+center_of_sling_shot,
					0.5
				)
				if (projectile.global_position - global_position - center_of_sling_shot).length() < 0.1:
					SlingShotState = SlingState.idle



func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if SlingShotState == SlingState.idle:
		if (event is InputEventMouseButton && event.is_pressed()):
			SlingShotState = SlingState.pulling
	pass # Replace with function body.
