extends Node2D

class_name Entity

@export var hitbox_height := 16.0
@export var hitbox_width := 23.0
@export var character_frames_res = "res://scenes/frames/seeker_frames.tscn"
@export var min_idle_time = 3.0
@export var max_idle_time = 10.0

@onready var hitbox := $Area2D/CollisionShape2D
@onready var player := get_tree().current_scene.get_node_or_null("Player") as Player
@onready var navigation := $NavigationAgent2D

var frames = null
var assigned_area = null
var idle_time = 0.0
var idle_timer = 0.0

const SPEED = 200.0

func _ready() -> void:
	if assigned_area == null:
		print("No assigned area. Entity wont move.")
		return
	
	idle_time = randf_range(min_idle_time, max_idle_time)
	
	navigation.target_position = global_position

func _process(delta: float) -> void:
	if player == null:
		return
		
	if assigned_area == null:
		return
		
	if navigation.is_navigation_finished():
		_set_new_random_target()
		idle_timer = 0.0
	
	if not navigation.is_target_reachable():
		print("Unreachable pos:", navigation.target_position)
		_set_new_random_target()
	
	idle_timer += delta
	
	if idle_timer > idle_time:
		var next_point = navigation.get_next_path_position()
		var dir = next_point - global_position
		global_position += dir.normalized() * SPEED * delta

func _set_new_random_target() -> void:
	var rect = assigned_area.shape.get_rect()
	
	var local_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var local_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	var local_point = Vector2(local_x, local_y)
	
	var world_point = assigned_area.to_global(local_point)
	var nav_map = navigation.get_navigation_map()
	world_point = NavigationServer2D.map_get_closest_point(nav_map, world_point)
	navigation.target_position = world_point
