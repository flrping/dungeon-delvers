extends CharacterBody2D

class_name RyonAllySpell

var speed: float = 400.0
var life_timer: float = 0.0

@onready var area = $Hitbox
	
func _physics_process(delta: float) -> void:
	life_timer += delta
	
	if life_timer > 1.0:
		queue_free()
		return
	
	var facing = velocity.normalized()
	rotation = facing.angle()
	
	for source in area.get_overlapping_bodies():
		if source.is_in_group("Enemy"):
			queue_free()
			return
			
	move_and_slide()
