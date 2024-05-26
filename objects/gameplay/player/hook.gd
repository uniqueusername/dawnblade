extends Node2D

@export var PULL_STRENGTH: float = 25.0

var hooked: bool = false

func _physics_process(delta):
	if hooked:
		var target_dir: Vector2 = ($hook.position - get_parent().global_position).normalized()
		get_parent().velocity += target_dir * PULL_STRENGTH

func _process(delta):
	look_at(get_global_mouse_position())
	rotation -= PI/2

func _shoot_hook():
	if $RayCast2D.is_colliding():
		$hook.global_position = $RayCast2D.get_collision_point()
		hooked = true

func _release_hook():
	$hook.global_position = Vector2.ZERO
	hooked = false

func _on_new_inputs(inputs):
	if "grapple" in inputs: _shoot_hook()
	elif "ungrapple" in inputs: _release_hook()
