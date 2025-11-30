extends CharacterBody2D

class_name Trident

var player: RyonPlayer
var speed: float = 800.0
var is_coming_home: bool = false

@onready var area = $Hitbox
	
func _physics_process(delta: float) -> void:
	var facing = velocity.normalized()
	rotation = facing.angle()
	
	if is_coming_home:
		var dir := (player.global_position - global_position).normalized()
		velocity = dir * speed
		
		for source in area.get_overlapping_bodies():
			if source.is_in_group("Player"):
				player.has_spawned = false
				player.is_recovering = false
				queue_free()
				return
			
	move_and_slide()
