extends Entity

class_name SlimeEnemy

const ATTACK_DISTANCE := 64.0
const MOVE_WAIT_TIME := 2
const JUMP_DURATION: float = 0.5

@export var slime_type: String = "Green"

@onready var frames: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox: Area2D = $Hurtbox

var target: Node2D
var last_known_target_pos: Vector2
var can_refresh_target: bool = true

func _ready() -> void:
	speed = 150.0
	
	states = {
		"idle": preload("res://scripts/entity/states/entity_idle_state.gd").new(),
		"wander": preload("res://scripts/entity/states/entity_wander_state.gd").new(),
	}
	
	if slime_type == "Yellow":
		states.set("hunt", preload("res://scripts/entity/states/slimes/yellow_slime_hunt_state.gd").new())
	else:
		states.set("hunt", preload("res://scripts/entity/states/slimes/slime_hunt_state.gd").new())
	
	for _state in states.values():
		_state.entity = self
		add_child(_state)
	
	_set_state("idle")
	
	if job == "captain":
		max_health = max_health * 2
		speed = speed * 0.75
	
	frames.play(slime_type.to_lower() + "_move")
	navigation.target_position = global_position

func _physics_process(delta: float) -> void:
	if not state:
		return
		
	if assigned_area == null:
		return
	
	if knockback_timer <= 0.0:
		_check_for_targets()
		_apply_i_frames(delta)
	
		state.physics_update(delta)
	else:
		knockback_timer -= delta
		
	_check_damage_sources(delta, hurtbox)
	
	move_and_slide()

func _check_for_targets() -> void:
	var found: bool = false
	for detected in detection.get_overlapping_bodies():
		if detected.is_in_group("Ally") and can_refresh_target:
			target = detected
			found = true
			_set_state("hunt")
			return
	
	if !found:
		target = null
