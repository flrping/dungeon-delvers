extends CharacterBody2D

class_name Player

const SPEED = 300.0

@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 300.0 # in ms
@export var i_frame_timer = 0.0

@onready var frames: AnimatedSprite2D = $MeredithFrames
@onready var hitbox: Area2D  = $Hitbox
@onready var hitbox_shape: CollisionShape2D  = $Hitbox/CollisionShape2D
@onready var health_bar = $CanvasLayer/HealthBar
@onready var attack_hitbox_up: Area2D  = $AttackUpHitbox
@onready var attack_hitbox_down: Area2D  = $AttackDownHitbox
@onready var attack_hitbox_left: Area2D  = $AttackLeftHitbox
@onready var attack_hitbox_right: Area2D  = $AttackRightHitbox

var prev_animation = ""
var is_attacking = false

signal on_player_damage

func _ready() -> void:
	health_bar.max_value = max_health

func _process(delta: float) -> void:
	_search_damage_sources(delta)
	_attack(delta)
	_apply_movement(delta)
	
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)
	
func _search_damage_sources(_delta) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hitbox.get_overlapping_areas():
		if source.is_in_group("EnemyDamageSource"):
			# take flat damage for now
			_take_damage(5.0)
			i_frame_timer = i_frame / 1000.0
			return

func _attack(_delta) -> void:
	if is_attacking:
		return
	
	if Input.is_action_just_pressed("Light_Attack"):
		is_attacking = true
		prev_animation = frames.animation
		var attack_animation := ""
		
		_disable_all_attack_shapes()
		
		var shape_to_enable: CollisionShape2D
		
		if frames.animation == "walk_left":
			attack_animation = "attack_side"
			if frames.flip_h:
				shape_to_enable = attack_hitbox_right.get_node("CollisionShape2D")
			else:
				shape_to_enable = attack_hitbox_left.get_node("CollisionShape2D")
		elif frames.animation == "walk_up": 
			attack_animation = "attack_down" # temp
			shape_to_enable = attack_hitbox_up.get_node("CollisionShape2D")
			frames.offset.y = -8 
			frames.flip_v = true
		else:
			attack_animation = "attack_down"
			shape_to_enable = attack_hitbox_down.get_node("CollisionShape2D")
			frames.offset.y = 8
			
		shape_to_enable.disabled = false
		frames.play(attack_animation)
		await frames.animation_finished
		frames.offset.y = 0
		frames.flip_v = false
		shape_to_enable.disabled = true

		frames.play(prev_animation)
		is_attacking = false

func _disable_all_attack_shapes() -> void:
	attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	attack_hitbox_right.get_node("CollisionShape2D").disabled = true
	
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
	
	on_player_damage.emit(amount)

func _on_on_player_damage(_amount: float) -> void:
	health_bar.value = current_health
