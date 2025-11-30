extends CharacterBody2D

class_name Entity

@export var max_health: float = 20.0
@export var current_health: float = 20.0
@export var i_frame: float = 200.0 # in ms
@export var i_frame_timer: float = 0.0
@export var min_idle_time: float = 3.0
@export var max_idle_time: float = 10.0
@export var attack_time: float = 3.0
@export var damage_source: String = "EnemyDamageSource"
@export var job: String = "none"
@export var speed: float = 150.0

@onready var navigation := $NavigationAgent2D
@onready var enemy_hit := preload("res://assets/sfx/HitEnemy.wav")

var assigned_area: CollisionShape2D
var idle_time: float = 0.0
var idle_timer: float = 0.0
var attack_timer: float = 0.0
var jobs: Array[Variant] = ["none", "captain", "party"]

var state: EntityState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2

# Sets states.
func _set_state(state_name) -> void:
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if state == states[state_name]:
		return

	if state:
		state.exit(states[state_name])

	var prev: EntityState = state
	state = states[state_name]
	state.enter(prev)

# Finds a path from their assigned areas.
func _set_new_random_target() -> void:
	var rect = assigned_area.shape.get_rect()
	
	var local_x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var local_y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	var local_point: Vector2 = Vector2(local_x, local_y)
	
	var world_point = assigned_area.to_global(local_point)
	var nav_map: RID = navigation.get_navigation_map()
	world_point = NavigationServer2D.map_get_closest_point(nav_map, world_point)
	navigation.target_position = world_point

# Applies invincibility frames.
func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)

# Checks for damage sources overlapping with the hurtbox.
func _check_damage_sources(_delta: Variant, hurtbox: Area2D) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group(damage_source) and not source.is_in_group("Player"):
			var knockback_dir: Vector2 = (global_position - source.global_position).normalized()
			_take_damage(source, 1.0, knockback_dir)
			i_frame_timer = i_frame / 1000.0
		elif source.is_in_group(damage_source) and source.is_in_group("Player"):
			var knockback_dir: Vector2 = (global_position - source.global_position).normalized()
			_take_damage(source, 10.0, knockback_dir)
			i_frame_timer = i_frame / 1000.0
			
# Handles taking damage and death.
func _take_damage(source: Variant, amount: float, knockback_dir: Vector2) -> void:
	velocity = knockback_dir * 250.0
	current_health -= amount
	
	SoundBus._queue_sound("enemy_hit", enemy_hit, position)
	
	Bus.emit_signal("on_enemy_damage", self, source)
	if current_health <= 0:
		Bus.emit_signal("on_enemy_death", self, source)
		queue_free()
