extends CharacterBody2D

class_name Entity

const SPEED: float = 200.0

@export var state: String = "idle"
@export var min_idle_time: float = 3.0
@export var max_idle_time: float = 10.0
@export var search_time: float = 5.0

@onready var navigation := $NavigationAgent2D

var assigned_area = null

var states: Array[Variant] = ["idle", "wander", "hunt", "search"]
var idle_time: float = 0.0
var idle_timer: float = 0.0
var search_timer: float = 0.0

# Warns if any entity is not prepared correctly. All mob entities need these.
func _check_init() -> void:
	if assigned_area == null:
		print("No assigned area. Entity is frozen.")
		return
		
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
