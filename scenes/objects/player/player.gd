extends CharacterBody2D

signal skid

@export var input_collector: Node = get_node_or_null("input_collector")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var START_WEIGHT: float = 0.5 # lerp rate
@export var STOP_RATE: float = 100.0
@export var MAX_SPEED: float = 400.0
@export var JUMP_VELOCITY: float = -400.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# process polled inputs
	if input_collector:
		
		# movement
		var move_power = input_collector.get_move_power()
		if move_power:
			if move_power * velocity.x < 0: skid.emit()
			velocity.x = lerpf(velocity.x, move_power * MAX_SPEED, START_WEIGHT)
		else:
			velocity.x = move_toward(velocity.x, 0, STOP_RATE)

	move_and_slide()

func _on_new_inputs(inputs):
	if "jump" in inputs and is_on_floor(): velocity.y = JUMP_VELOCITY 
