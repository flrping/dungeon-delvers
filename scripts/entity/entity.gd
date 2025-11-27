extends CharacterBody2D

class_name Entity

const SPEED: float = 200.0

@export var max_health = 20.0
@export var current_health = 20.0
@export var i_frame = 200.0 # in ms
@export var i_frame_timer = 0.0
@export var state: String = "idle"
@export var min_idle_time: float = 3.0
@export var max_idle_time: float = 10.0
@export var search_time: float = 5.0
@export var damage_source: String = "EnemyDamageSource"

@onready var navigation := $NavigationAgent2D

var assigned_area = null
var states: Array[Variant] = ["idle", "wander", "hunt", "search"]
var idle_time: float = 0.0
var idle_timer: float = 0.0
var search_timer: float = 0.0

# Warns if any entity is not prepared correctly. All mob entities need these.
func _init() -> void:
	#if assigned_area == null:
		#print("No assigned area. Entity is frozen.")
		#return
		
	if state not in states:
		print("Invalid state. Using idle.")
		state = "idle"
		return

# Sets states.
func _set_state(next_state) -> void:
	if state == next_state or next_state not in states:
		return
	state = next_state

# Shared func so any entity can wander around. It is safe to assume all entities will do this.
func _wander(_delta) -> void:
	var next_point: Vector2 = navigation.get_next_path_position()
	var dir: Vector2 = next_point - global_position
	velocity = dir.normalized() * SPEED
	move_and_slide()

# Shared func so any entity can pathfind from their assigned areas.
func _set_new_random_target() -> void:
	var rect = assigned_area.shape.get_rect()
	
	var local_x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var local_y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	var local_point: Vector2 = Vector2(local_x, local_y)
	
	var world_point = assigned_area.to_global(local_point)
	var nav_map: RID = navigation.get_navigation_map()
	world_point = NavigationServer2D.map_get_closest_point(nav_map, world_point)
	navigation.target_position = world_point

func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)

func _check_damage_sources(_delta: Variant, hitbox: Area2D) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hitbox.get_overlapping_areas():
		if source.is_in_group(damage_source):
			_take_damage(10.0)
			i_frame_timer = i_frame / 1000.0
			return

func _take_damage(amount: float) -> void:
	current_health -= amount
	
	# TODO: find/set sources
	Bus.emit_signal("on_enemy_damage", self, null)

	if current_health <= 0:
		Bus.emit_signal("on_enemy_death", self, null)
		queue_free()
