class_name Player_Walk_State extends Player_State


func enter_state() -> void:
	print("Entered Walk")
	Entity.Speed = Entity.Walk

func exit_state() -> void:
	print("Exited Walk")
	Entity.velocity = Vector3.ZERO
	
func unhandled_state_input(_event) -> void:
	Entity.Rotate_Player(_event)

func physics_update(_delta) -> void:
	Entity.Apply_Input()
	Entity.Apply_Gravity(_delta)
	Entity.Handle_Movement()

func update(_delta) -> void:
	pass
	
func get_next_state() -> int:
	if Input.is_action_pressed("Jump"):
		return States.Jump
	
	if Entity.Keys_Input == Vector2.ZERO:
		return States.Idle
	
	if Input.is_action_pressed("Sprint"):
		return States.Sprint
	
	
	
	return Key
