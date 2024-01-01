# Dragon20C 19/12/2023
# FPS player controller
# Godot version : 4.2.1

class_name Player extends CharacterBody3D

@export_group("Bools")
@export var mouse_capture : bool = true # Capture the mouse
@export var can_move : bool = true # Allow the player to move
@export var can_sprint : bool = true # Allow the player to move
@export var sprinting : bool = false # Check if the player is sprinting
@export var allow_fall_input = true #Alow player to input move when falling
@export_group("Parameters")
@export var mouse_sensitivity : float = 0.005 # Mouse sensitivity 
@export var mouse_acceleration : float = 50.0 # Mouse acceleration
@export var walk_speed : int = 6 # Player walk speed
@export var sprint_speed : int = 10 # Player sprint speed
@export var move_acceleration : int = 7 # Speed up acceleration
@export var move_deceleration : int = 10 # Speed down deceleration
@export var jump_force : float = 4.5 # The force of the jump
@export var jump_vector : Vector3 = Vector3.UP # Vector to hold up
@export var gravity_vector : Vector3 = Vector3.DOWN # Vector to hold down
@export_group("Head bobbing Parameters")
@export var frequency : float = 1.0
@export var amplitude : float = 0.1
@export_group("Footstep Parameters")
@export var sound_effects : Array[AudioStream]
@onready var audio_emitter : AudioStreamPlayer3D = get_node("AudioEmitter")

var rate : float = 0.0
var stepped : bool = false
@onready var head : Node3D = get_node("Head")
@onready var camera : Camera3D = get_node("Head/Camera_stab/Camera3D")
@onready var camera_stab : Node3D = get_node("Head/Camera_stab")
@onready var stab_target : Marker3D = get_node("Head/Camera_stab/Target_stab")
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") # Gravity from settings


var player_rotation : float = 0
var head_rotation : float = 0

func _ready():
	if mouse_capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		apply_rotation(-event.relative * mouse_sensitivity * 0.1)
	
func apply_rotation(mouse_motion : Vector2) -> void:
	rotate_y(mouse_motion.x)
	head.rotate_x(mouse_motion.y)
	head.rotation.x = clamp(head.rotation.x, -PI / 2, PI / 2)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	movement(delta)
	head_bobbing(delta)
	camera_stabilisation()

func movement(delta : float) -> void:
	var key_input = Vector3.ZERO
	if can_move and (is_on_floor() or allow_fall_input):
		key_input = Input.get_vector("Left", "Right", "Forward", "Backward")
		#Jump
		if Input.is_action_pressed("Jump") and is_on_floor():
			velocity += jump_vector * jump_force - (jump_vector * -1).normalized() * velocity.dot(jump_vector * -1)
	
		#Sprint toggle
		if can_sprint and Input.is_action_just_pressed("Sprint") and is_on_floor():
			sprinting = true
			
		if can_sprint and not Input.is_action_pressed("Sprint") and is_on_floor():
			sprinting = false
	
	#Smooth movement
	var direction = transform.basis * (Vector3(key_input.x,0,key_input.y).normalized()) * (sprint_speed if sprinting else walk_speed)
	
	if is_on_floor() or direction != Vector3.ZERO:
		var acceleration = move_acceleration if direction.dot(velocity) else move_deceleration
		var vp = gravity_vector.normalized() * velocity.dot(gravity_vector)
		velocity = (velocity - vp).lerp(direction, acceleration * delta) + vp

	
	#Gravaty
	if !is_on_floor():
		velocity += gravity_vector * gravity * delta

	move_and_slide()

func head_bobbing(delta : float) -> void:
	if velocity.length() > 0 and is_on_floor():
		rate += delta * velocity.length()
		var motion = bob_motion()
		
		camera.transform.origin = lerp(camera.transform.origin,motion,20 * delta)
		
		if motion.y < -amplitude + 0.01 and not stepped:
			stepped = true
			play_step_sound()
		elif motion.y > -0.01:
			stepped = false
	elif velocity.length() == 0 or not is_on_floor():
		restart_camera(delta)

func bob_motion() -> Vector3:
	var pos = Vector3.ZERO
	pos.y = -abs(sin(rate * frequency) * amplitude)
	pos.x = sin(rate * frequency) * amplitude
	return pos

func play_step_sound() -> void:
	var random_index : int = randi_range(0,sound_effects.size() - 1)
	audio_emitter.stream = sound_effects[random_index]
	audio_emitter.pitch_scale = randf_range(0.9,1.1)
	audio_emitter.play()

func restart_camera(delta):
	if camera.transform.origin == Vector3.ZERO: return
	
	camera.transform.origin = camera.transform.origin.lerp(Vector3.ZERO,10 * delta)
	rate = 0.0

func camera_stabilisation() -> void:
	camera.look_at(stab_target.global_position)
