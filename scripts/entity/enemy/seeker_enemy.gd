extends Entity

class_name SeekerEnemy

const ATTACK_DISTANCE := 12.0

@onready var frames: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox: Area2D = $Hurtbox

var target: Node2D
var last_known_target_pos: Vector2
var can_refresh_target = true

func _ready() -> void:
	_init()
	frames.play("walk_down")
	idle_time = randf_range(min_idle_time, max_idle_time)
	navigation.target_position = global_position

func _process(delta: float) -> void:
	if assigned_area == null:
		return
	
	_check_for_targets()
	_apply_state(delta)
	_apply_i_frames(delta)
	_check_damage_sources(delta, hurtbox)

func _check_for_targets():
	var found = false
	for detected in detection.get_overlapping_bodies():
		if detected.is_in_group("Ally") and can_refresh_target:
			target = detected
			found = true
			_set_state("hunt")
			return
			
	if !found:
		target = null

func _apply_state(delta):
	if state == "idle":
		idle_timer += delta
		if idle_timer >= idle_time:
			_set_state("wander")
	
	elif state == "wander":
		if navigation.is_navigation_finished():
			_set_new_random_target()
			idle_timer = 0.0
			_set_state("idle")
			return
			
		if not navigation.is_target_reachable():
			print("Unreachable pos:", navigation.target_position)
			_set_new_random_target()
			return
			
		_wander(delta)
		
	elif state == "hunt":
		_hunt(delta)

func _hunt(_delta):
	if target == null:
		idle_timer = idle_time
		_set_state("idle")
		return
		
	var target_pos = target.global_position
	last_known_target_pos = target_pos
	var dist = global_position.distance_to(target_pos)
		
	if dist <= ATTACK_DISTANCE:
		navigation.target_position = global_position
	else:
		navigation.target_position = target_pos
	
	var next_point: Vector2 = navigation.get_next_path_position()
	var dir: Vector2 = next_point - global_position
	velocity = dir.normalized() * speed
	move_and_slide()
