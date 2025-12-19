extends Sprite2D

enum{
	STATE_IDLE,
	STATE_TRANSFERED,
	STATE_ATTACHED,
	STATE_DRAGGER,
	STATE_RELEASED,
	STATE_LAUNCHED
}

var state = STATE_IDLE
var slingshot = null

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#._integrate_forces(state)
	var lv = state.get_linear_velocity()
	#var av = state.angular_velocity()
	var delta = 1 / state.get_step()
	
	match state:
		STATE_TRANSFERED:
			pass
			
		STATE_ATTACHED:
			pass
			
		STATE_DRAGGER:
			pass
			
		STATE_RELEASED:
			pass
			
		STATE_LAUNCHED:
			pass
	
	state.set_linear_velocity(lv)
	#state.set_angular_velocity(av)
	
func attach_to(slingshot):
	self.slingshot = slingshot
	state = STATE_TRANSFERED
