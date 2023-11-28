class_name Player_Jump_State extends Player_State


func enter_state() -> void:
	print("Entered Jump")
	Entity.Handle_Jump()

func exit_state() -> void:
	print("Exited Jump")

	
func unhandled_state_input(_event) -> void:
	Entity.Rotate_Player(_event)

func physics_update(_delta) -> void:
	Entity.Apply_Input()
	Entity.Apply_Gravity(_delta)
	Entity.Handle_Movement()

func update(_delta) -> void:
	pass
	
func get_next_state() -> int:
	if Entity.is_on_floor():
		if Entity.Keys_Input == Vector2.ZERO:
			return States.Idle
		elif Input.is_action_pressed("Sprint"):
			return States.Sprint
		else:
			return States.Walk
	
	return Key
