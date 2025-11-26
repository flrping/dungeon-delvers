extends CharacterBody2D

class_name Player

@export var character_frames_res = "res://scenes/frames/meredith_frames.tscn"
var frames = null

const SPEED = 300.0

func _ready() -> void:
	frames = load(character_frames_res).instantiate() as Node2D
	add_child(frames)

func _process(_delta: float) -> void:
	velocity = Vector2.ZERO
	var x_direction := Input.get_axis("ui_left", "ui_right")
	if x_direction > 0:
		velocity.x += 1
		frames.play("walk_right")
		frames.flip_h = false
	if x_direction < 0:
		velocity.x -= 1
		frames.play("walk_right")
		frames.flip_h = true
	
	var y_direction := Input.get_axis("ui_up", "ui_down")
	if y_direction > 0:
		velocity.y += 1
		frames.play("walk_down")
	if y_direction < 0:
		velocity.y -= 1
		frames.play("walk_up")
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	else: 
		frames.stop()
	
	move_and_slide()
