extends Entity

class_name Ally

const ATTACK_DISTANCE := 12.0

@onready var frames: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox: Area2D = $Hurtbox

var target: Node2D
var last_known_target_pos: Vector2
var can_refresh_target = true

func _ready() -> void:
	speed = 185.0
	
	states = {
		"idle": preload("res://scripts/entity/states/entity_idle_state.gd").new(),
		"wander": preload("res://scripts/entity/states/entity_wander_state.gd").new(),
		"hunt": preload("res://scripts/entity/states/entity_hunt_state.gd").new()
	}
	
	for _state in states.values():
		_state.entity = self
		add_child(_state)
	
	_set_state("idle")
	
	if job == "captain":
		max_health = max_health * 2
		speed = speed * 0.75
	
	navigation.target_position = global_position

func _physics_process(delta: float) -> void:
	if not state:
		return
		
	if assigned_area == null:
		return
		
	match facing_direction:
		Vector2.UP:
			frames.play("walk_up")
		Vector2.DOWN:
			frames.play("walk_down")
		Vector2.LEFT:
			frames.play("walk_side")
			frames.flip_h = true
		Vector2.RIGHT:
			frames.play("walk_side")
			frames.flip_h = false
	
	_check_for_targets()
	_apply_i_frames(delta)
	_check_damage_sources(delta, hurtbox)
	
	state.physics_update(delta)

func _check_for_targets():
	var found = false
	for detected in detection.get_overlapping_bodies():
		if detected.is_in_group("Enemy") and can_refresh_target:
			target = detected
			found = true
			_set_state("hunt")
			return
	
	if not found:
		target = null
