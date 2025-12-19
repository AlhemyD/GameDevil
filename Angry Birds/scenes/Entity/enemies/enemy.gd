extends RigidBody2D

@export var damage_from_velocity = 10
@export var health = 150.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t = get_tree().create_timer(3)

	await t.timeout
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if is_instance_valid(body):
		if body is RigidBody2D:
			if body.is_in_group("Projectile"):
				queue_free()
			else:
				var damage = body.linear_velocity.length() * damage_from_velocity
				health -= damage
				if health <= 0:
					queue_free()
		
	pass # Replace with function body.
