extends Node

@export_group("Exports Required")
@export var Camera : Camera3D 
@export var Stabilizer_Marker : Marker3D
@export var Target : CharacterBody3D
@export var Ground_Audio_Emitter : AudioStreamPlayer3D

@export_group("Head Motion States")
@export var Head_Motion_State : bool = true
@export var Camera_Stabilizer_State : bool = true

@export_group("Head Motion Values")
@export var Frequency : float = 1.2
@export var Amplitude : float = 0.12
var Stored_Time : float = 0.0

@export_group("Footstep Sounds")
var Stepped : bool = false
@export var Footstep_Sounds : Array[AudioStreamWAV]


func _physics_process(delta) -> void:
	#Head bobbing motion
	Head_Motion(delta)

func Head_Motion(delta) -> void:
	if not Head_Motion_State: return

	if Target.velocity.length() > 0 and Target.is_on_floor():
		Stored_Time += delta * Target.velocity.length()
		var Motion = Bobbing_Motion()
		if Motion.y < -Amplitude + 0.01 and not Stepped:
			Stepped = true
			Play_Step()
		elif Motion.y > -0.01:
			Stepped = false
		
		Camera.transform.origin = lerp(Camera.transform.origin,Motion,15 * delta)
		if Camera_Stabilizer_State:
			Camera.look_at(Stabilizer_Marker.global_position)
	else:
		Rest_Position(delta)
		
func Rest_Position(delta):
	if Camera.transform.origin == Vector3.ZERO: return
	
	Camera.transform.origin = Camera.transform.origin.lerp(Vector3.ZERO,10 * delta)
	Stored_Time = 0.0

func Bobbing_Motion() -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y = -abs(sin(Stored_Time * Frequency) * Amplitude)
	pos.x = sin(Stored_Time * Frequency) * Amplitude
	
	return pos

func Play_Step():
	var Random_Index : int = randi_range(0,Footstep_Sounds.size() - 1)
	Ground_Audio_Emitter.stream = Footstep_Sounds[Random_Index]
	Ground_Audio_Emitter.pitch_scale = randf_range(0.8,1.2)
	Ground_Audio_Emitter.play()
