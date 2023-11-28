class_name StateMachineSystem extends Node

enum Entity_States {Idle,Walk,Sprint,Jump,Fall}
@export var Entity : CharacterBody3D
@export var Inital_State : Entity_States
var States = {}
var Current_State : State
var Transitioning : bool = false

# in the process function we check for a state change then we update it.

func _ready():
	Ready_States()
	Current_State = States[Inital_State]

# Use the Add State function to add states to the machine.
func Ready_States() -> void:
	pass

# A add state function so we can add the states to our states dictionary
func Add_State(New_State : State, Enum_State : Entity_States) -> void:
	New_State.Entity = Entity
	New_State.States = Entity_States
	New_State.Key = Enum_State
	States[Enum_State] = New_State

func _unhandled_input(event) -> void:
	if Transitioning: return
	Current_State.unhandled_state_input(event)

func _process(delta) -> void:
	var next_state = Current_State.get_next_state()
	
	if not Transitioning and next_state == Current_State.Key:
		Current_State.update(delta)
	elif not Transitioning:
		transition_to_state(next_state)
	
func _physics_process(delta) -> void:
	if Transitioning: return
	Current_State.physics_update(delta)

func transition_to_state(next_state : Entity_States) -> void:
	Transitioning = true
	Current_State.exit_state()
	Current_State = States.get(next_state)
	Current_State.enter_state()
	Transitioning = false
	

