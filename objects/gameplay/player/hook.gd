extends Node2D

@export var input_collector: Node2D
@export var PULL_STRENGTH: float = 25.0
@export var RANGE: float = 750.0:
	set(value):
		RANGE = value
		_config_range(RANGE)

var hooked: bool = false
var target_dir: Vector2 = Vector2.ZERO

func _ready():
	_config_range(RANGE)

func _physics_process(delta):
	if hooked:
		get_parent().velocity += target_dir * PULL_STRENGTH

func _process(delta):
	rotation = target_dir.angle() - PI/2
	
	if hooked:
		var chain_length: float = get_parent().global_position.distance_to($hook.position)
		$hook/chain.region_rect.size.y = chain_length
		$hook/chain.offset.y = chain_length / 2
		
		$hook.look_at(get_parent().global_position)
		$hook.rotation -= PI/2

func _shoot_hook():
	if $RayCast2D.is_colliding():
		$hook.global_position = $RayCast2D.get_collision_point()
		$hook.visible = true
		$RayCast2D.visible = false
		hooked = true

func _release_hook():
	$hook.visible = false
	$RayCast2D.visible = true
	hooked = false
	
func _config_range(range: float):
	$RayCast2D.target_position.y = range
	$RayCast2D/target.region_rect.size.y = range - 100
	$RayCast2D/target.offset.y = (range - 100) / 2 + 50
	
	$RayCast2D/reticle.position.y = range

func _on_new_inputs(inputs):
	target_dir = input_collector.get_aim()
	if "grapple" in inputs: _shoot_hook()
	elif "ungrapple" in inputs: _release_hook()
