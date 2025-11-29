extends CharacterBody2D

class_name Player

const SPEED = 300.0

@export var max_health = 100.0
@export var current_health = 100.0
@export var i_frame = 800.0
@export var i_frame_timer = 0.0

@onready var frames: AnimatedSprite2D = $Frames
@onready var hurtbox: Area2D  = $Hurtbox

var state: PlayerState
var states: Dictionary[Variant, Variant] = {}
var facing_direction: Vector2

# Sets states.
func _set_state(state_name) -> void:
	if not states.has(state_name):
		push_warning("State '%s' not found" % state_name)
		return

	if state == states[state_name]:
		return

	if state:
		state.exit(states[state_name])

	var prev: PlayerState = state
	state = states[state_name]
	state.enter(prev)

func _apply_i_frames(delta):
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)
	
func _check_damage_sources(_delta) -> void:
	if i_frame_timer > 0.0:
		return
	
	for source in hurtbox.get_overlapping_areas():
		if source.is_in_group("EnemyDamageSource"):
			_take_damage(5.0)
			i_frame_timer = i_frame / 1000.0
			return

func _take_damage(amount: float) -> void:
	if amount >= current_health:
		# die stuff
		pass
	else:
		current_health -= amount
	
	Bus.emit_signal("on_player_damage", self)
