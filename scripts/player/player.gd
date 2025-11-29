extends CharacterBody2D

class_name Player

const SPEED = 300.0

@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 300.0 # in ms
@export var i_frame_timer = 0.0

@onready var frames: AnimatedSprite2D = $Frames
@onready var hurtbox: Area2D  = $Hurtbox

var prev_animation = ""
var is_attacking = false

func _ready() -> void:
	pass
	
func _check_damage_sources(_delta) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group("EnemyDamageSource"):
			_take_damage(5.0)
			i_frame_timer = i_frame / 1000.0
			return
	
func _apply_movement(_delta) -> void:
	velocity = Vector2.ZERO
	var x_direction := Input.get_axis("Left", "Right")
	if x_direction > 0:
		velocity.x += 1
		if not is_attacking: 
			frames.play("walk_left")
			frames.flip_h = true
	if x_direction < 0:
		velocity.x -= 1
		if not is_attacking: 
			frames.play("walk_left")
			frames.flip_h = false
	
	var y_direction := Input.get_axis("Up", "Down")
	if y_direction > 0:
		velocity.y += 1
		if not is_attacking:
			frames.play("walk_down")
	if y_direction < 0:
		velocity.y -= 1
		if not is_attacking:
			frames.play("walk_up")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	else:
		if not is_attacking:
			frames.play("idle")
			
	move_and_slide()

func _take_damage(amount: float) -> void:
	if amount >= current_health:
		# die stuff
		pass
	else:
		current_health -= amount
	
	Bus.emit_signal("on_player_damage", self)
