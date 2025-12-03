extends CharacterBody2D

class_name JadeProjectile

var speed: float = 400.0
var life_timer: float = 0.0
var has_hit: = false
var is_ready = false

@onready var area := $Hitbox
@onready var frames := $Frames

func _ready() -> void:
	frames.play("default")

func _physics_process(delta: float) -> void:
	life_timer += delta
	
	if life_timer > 1.0 and not has_hit:
		queue_free()
		return
	
	var facing = velocity.normalized()
	rotation = facing.angle()

	move_and_slide()
	
func _transform():
	var collision = area.get_node("CollisionShape2D")
	collision.disabled = true
	has_hit = true
	velocity = Vector2.ZERO
	frames.rotation = 0.0
	frames.play("rooted")
	await frames.animation_finished
	is_ready = true
	collision.disabled = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and not has_hit:
		_transform()
	elif body.is_in_group("Enemy") and has_hit and is_ready:
		queue_free()
