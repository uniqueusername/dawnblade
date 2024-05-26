# input collector api
# + get_move_power(): returns a move input from [-1, 1] power

# event inputs:
# + jump

extends Node2D

signal new_inputs

var mnk: bool = true
var move_power: float = 0.0 # horizontal movement input
var aim_dir: Vector2 = Vector2.ZERO

func _input(event):
	# detect controller
	mnk = not event is InputEventJoypadMotion 

	# store movement axis
	move_power = clamp(Input.get_axis("left", "right"), -1.0, 1.0)
	
	# store aim vector
	if mnk: aim_dir = get_local_mouse_position().normalized()
	else:
		var temp_dir: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		if temp_dir != Vector2.ZERO: aim_dir = temp_dir
	
	# collect single-frame inputs (e.g. jump)
	var inputs = []
	if Input.is_action_just_pressed("jump"): inputs.append("jump")
	if Input.is_action_just_pressed("grapple"): inputs.append("grapple")
	elif Input.is_action_just_released("grapple"): inputs.append("ungrapple")
	
	# send inputs to receiving components
	new_inputs.emit(inputs)

func get_move_power() -> float:
	return move_power

func get_aim() -> Vector2:
	return aim_dir
