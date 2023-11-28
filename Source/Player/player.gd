class_name Player extends CharacterBody3D

@export var Walk : float = 5.0
@export var Sprint : float = 8.0
@export var Speed : float = 0.0
var Keys_Input : Vector2 = Vector2.ZERO
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const BASE_SENSITIVITY := 0.005 # degrees per pixel
@export var Sensitivity : float = 34.0#0.0025

@export_group("Node Paths")
# node paths and variables
@export var Head : Node3D
@export var Camera_Stabilizer : Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func Rotate_Player(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		#  -event.relative * deg_to_rad(BASE_SENSITIVITY) * Sensitivity
		var Mouse_Motion = -event.relative * deg_to_rad(BASE_SENSITIVITY) * Sensitivity#-event.relative * Sensitivity
		Head.rotate_y(Mouse_Motion.x)
		Camera_Stabilizer.rotate_x(Mouse_Motion.y)
		Camera_Stabilizer.rotation.x = clamp(Camera_Stabilizer.rotation.x, -PI / 2, PI / 2)

func Apply_Gravity(delta) -> void:
	if not is_on_floor():
		velocity.y -= Gravity * delta

func Handle_Jump() -> void:
		velocity.y = JUMP_VELOCITY

func Apply_Input() -> void:
	Keys_Input = Input.get_vector("Left", "Right", "Forward", "Backward")

func Handle_Movement() -> void:
	var Direction = (Head.transform.basis * Vector3(Keys_Input.x, 0, Keys_Input.y)).normalized()
	
	
	if Direction:
		velocity.x = Direction.x * Speed
		velocity.z = Direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)

	move_and_slide()
