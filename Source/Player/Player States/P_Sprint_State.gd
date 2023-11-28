class_name Player_Sprint_State extends Player_State


func enter_state() -> void:
	print("Entered Sprint")
	Entity.Speed = Entity.Sprint

func exit_state() -> void:
	print("Exited Sprint")
	
	
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
	
	if not Input.is_action_pressed("Sprint"):
		return States.Walk
	
	
	
	return Key
