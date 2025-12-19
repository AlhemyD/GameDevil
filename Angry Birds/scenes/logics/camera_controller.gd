extends Camera2D

var startingPos
var projectile
var followingProjectile = false
var tween: Tween

@export var min_pos_cam = 580
@export var max_pos_cam = 1150
var elapsed_time = 0.0 
var duration = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startingPos = global_position
	#print(startingPos)
	projectile = get_tree().get_nodes_in_group("Projectile")[0]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if followingProjectile:
		if is_instance_valid(projectile):
			var projectilePos = clamp(projectile.position.x, min_pos_cam, max_pos_cam)
			global_position = Vector2(projectilePos, startingPos.y)
		else:
			tween = get_tree().create_tween()
			followingProjectile = false
			var projectiles = get_tree().get_nodes_in_group("Projectile")
			if projectiles.size() > 0:
				projectile = projectiles[0]
			
			tween.tween_property(
				self,
				"position",
				startingPos,
				duration
			)
