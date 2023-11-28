class_name Player_State extends Node


var States : Dictionary
var Key : int
var Entity : Player


func enter_state() -> void:
	pass

func exit_state() -> void:
	pass
	
func unhandled_state_input(_event) -> void:
	pass

func physics_update(_delta) -> void:
	pass

func update(_delta) -> void:
	pass
	
func get_next_state() -> int:
	return Key
