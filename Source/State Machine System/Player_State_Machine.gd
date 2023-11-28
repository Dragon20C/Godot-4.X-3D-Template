class_name Player_StateMachineSystem extends Node

enum Entity_States {Idle,Walk,Sprint,Jump,Fall}
@export var Entity : CharacterBody3D
@export var Inital_State : Entity_States
var States = {}
var Current_State : Player_State
var Transitioning : bool = false

# in the process function we check for a state change then we update it.

func _ready():
	Ready_States()
	Current_State = States.get(Inital_State)
	Current_State.enter_state()

func _unhandled_input(event):
	if Transitioning: return
	Current_State.unhandled_state_input(event)

func _process(delta):
	var next_state = Current_State.get_next_state()
	
	if not Transitioning and Current_State.Key == next_state:
		Current_State.update(delta)
	elif not Transitioning:
		transition_to_state(next_state)
	
func _physics_process(delta):
	if Transitioning: return
	Current_State.physics_update(delta)

func transition_to_state(next_state : Entity_States) -> void:
	Transitioning = true
	Current_State.exit_state()
	Current_State = States.get(next_state)
	Current_State.enter_state()
	Transitioning = false
	
# A add state function so we can add the states to our states dictionary
func Add_State(New_State : Player_State, Enum_State : Entity_States) -> void:
	New_State.Entity = Entity
	New_State.States = Entity_States
	New_State.Key = Enum_State
	States[Enum_State] = New_State

func Ready_States() -> void:
	Add_State(Player_Idle_State.new(),Entity_States.Idle)
	Add_State(Player_Walk_State.new(),Entity_States.Walk)
	Add_State(Player_Sprint_State.new(),Entity_States.Sprint)
	Add_State(Player_Jump_State.new(),Entity_States.Jump)
