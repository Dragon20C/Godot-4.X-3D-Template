class_name Player extends CharacterBody3D

@export var Walk : float = 5.0
@export var Sprint : float = 8.0
@export var Speed : float = 0.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var Sensitivity : float = 0.0025

@export_group("Node Paths")
# node paths and variables
@export var Head : Node3D
@export var Camera_Stabilizer : Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		var Mouse_Motion = -event.relative * Sensitivity
		Head.rotate_y(Mouse_Motion.x)
		Camera_Stabilizer.rotate_x(Mouse_Motion.y)
		Camera_Stabilizer.rotation.x = clamp(Camera_Stabilizer.rotation.x, -PI / 2, PI / 2)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= Gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var Keys_Input = Input.get_vector("Left", "Right", "Forward", "Backward")
	var Direction = (Head.transform.basis * Vector3(Keys_Input.x, 0, Keys_Input.y)).normalized()
	
	if Input.is_action_pressed("Sprint"):
		Speed = Sprint
	else:
		Speed = Walk
	
	if Direction:
		velocity.x = Direction.x * Speed
		velocity.z = Direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)

	move_and_slide()
