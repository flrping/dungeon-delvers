extends CharacterBody2D

class_name Fireball

var speed: float = 600.0
var life_timer: float = 0.0

@onready var area = $Hitbox
	
func _physics_process(delta: float) -> void:
	life_timer += delta
	
	if life_timer > 2.0:
		queue_free()
		return
	
	var facing = velocity.normalized()
	rotation = facing.angle()
	
	move_and_slide()
