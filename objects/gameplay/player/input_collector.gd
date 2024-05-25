# input collector api
# + get_move_power(): returns a move input from [-1, 1] power

# event inputs:
# + jump

extends Node

signal new_inputs

var move_power: float = 0.0

func _input(event):
	# store movement axis
	move_power = clamp(Input.get_axis("left", "right"), -1.0, 1.0)
	
	# send single-frame inputs (e.g. jump)
	var inputs = []
	if event.is_action_pressed("jump"): inputs.append("jump")
	new_inputs.emit(inputs)

func get_move_power() -> float:
	return move_power
