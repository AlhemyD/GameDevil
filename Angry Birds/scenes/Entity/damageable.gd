extends RigidBody2D
class_name Damageable

@export_range(1, 1000)
var health: int = 10
@export var life_time = 2
@export var min_speed = Vector2(2, 2)

var processed_velocity: Vector2 = Vector2()
var processed_angular_velocity: Vector2 = Vector2()

enum ProjectileState{
	notThrown,
	thrown
}

var state = ProjectileState.notThrown

func _ready() -> void:
	freeze = true
	freeze_mode = RigidBody2D.FreezeMode.FREEZE_MODE_STATIC 

func _physics_process(delta: float) -> void:
	if state == ProjectileState.thrown && linear_velocity <= min_speed:
		var t = Timer.new()
		t.set_wait_time(life_time)
		t.one_shot = true
		self.add_child(t)
		t.start()
		await t.timeout
		var slingshot = get_tree().get_nodes_in_group("Slingshot")[0]
		slingshot.SlingShotState = slingshot.SlingState.reset
		queue_free()

#func _physics_process(delta):
	## Получаем текущую скорость
	#processed_velocity = get_linear_velocity()
#
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#for i in range(state.get_contact_count()):
		#var contact = state.get_contact_collider_object(i)
		#if contact == null:
			#continue  # Пропускаем, если объекта нет
		#
		## Скорость контактирующего объекта
		#var contact_velocity = state.get_contact_collider_velocity_at_position(i)
#
		## Собственная скорость в точке контакта (линейная)
		#var self_velocity = state.get_linear_velocity()
#
		## Разница скоростей
		#var v = contact_velocity - self_velocity
#
		## Отладка
		##print("Contact velocity:", contact_velocity)
		##print("Self velocity:", self_velocity)
		##print("Relative velocity:", v)
#
#
#func _on_body_entered(body: Node) -> void:
	## Передаем длину вектора скорости в качестве урона processed_velocity.length()*0.01
	#get_damage(processed_velocity.length()*0.01)

func get_damage(damage: float) -> void:
	damage = round(damage)
	if damage > 0:
		print("Damage:", damage)
		health -= damage
		if health <= 0:
			queue_free()
			
func attach_to(item=null):
	pass


func ThrowProjectile():
	#print(name)
	freeze_mode = RigidBody2D.FreezeMode.FREEZE_MODE_KINEMATIC
	freeze = false
	state = ProjectileState.thrown
