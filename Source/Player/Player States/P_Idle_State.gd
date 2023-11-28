class_name Player_Idle_State extends Player_State


func enter_state() -> void:
	Entity.Speed = Entity.Walk
	Entity.velocity = Vector3.ZERO
	print("Entered Idle")

func exit_state() -> void:
	print("Exited Idle")
	
func unhandled_state_input(_event) -> void:
	Entity.Rotate_Player(_event)

func physics_update(_delta) -> void:
	Entity.Apply_Input()
	if not Entity.is_on_floor():
		Entity.Apply_Gravity(_delta)

func update(_delta) -> void:
	pass
	
func get_next_state() -> int:
	if Input.is_action_pressed("Jump"):
		return States.Jump
		
	if Entity.Keys_Input != Vector2.ZERO:
		return States.Walk
	
	
	
	return Key
