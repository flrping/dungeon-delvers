extends Entity

class_name SlimeEnemy

# will split this class eventually

const ATTACK_DISTANCE := 64.0
const MOVE_WAIT_TIME := 3
const JUMP_DURATION = 0.25
const TICK_TIME := 1

@export var slime_type = "Green"

@onready var frames: AnimatedSprite2D = $Frames
@onready var detection: Area2D = $Detection
@onready var hurtbox: Area2D = $Hurtbox

var target: Node2D
var last_known_target_pos: Vector2
var can_refresh_target = true
var move_wait_timer = 0.0
var jump_timer = 0.0
var tick_timer = 0.0
var is_jumping = false
var is_ticking = false

func _ready() -> void:
	_init()
	frames.play(slime_type.to_lower() + "_move")
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

func _hunt(delta):
	if target == null:
		idle_timer = idle_time
		_set_state("idle")
		return
	
	move_wait_timer += delta
	
	if is_ticking:
		tick_timer += delta
		
		if tick_timer > TICK_TIME:
			frames.play("yellow_explode")
			await frames.animation_finished
			_take_damage(max_health, Vector2.ZERO)
		return
		
	var target_pos = target.global_position
	last_known_target_pos = target_pos
	var dist = global_position.distance_to(target_pos)
		
	if dist <= ATTACK_DISTANCE:
		if slime_type.to_lower() == "yellow":
			is_ticking = true
			frames.play("yellow_tick")
	else:
		navigation.target_position = target_pos
	
	if move_wait_timer < MOVE_WAIT_TIME:
		return
	
	if is_jumping:
		jump_timer += delta
		
		move_and_slide()
		if jump_timer >= JUMP_DURATION:
			is_jumping = false
			jump_timer = 0.0
			move_wait_timer = 0.0
			velocity = Vector2.ZERO
		return
		
	var next_point: Vector2 = navigation.get_next_path_position()
	var dir: Vector2 = next_point - global_position
	
	is_jumping = true
	jump_timer = 0.0
	
	velocity = dir.normalized() * speed * 2
