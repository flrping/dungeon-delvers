extends Node2D

@onready var boss_music_no_vocal: AudioStreamMP3 = preload("res://assets/tracks/xia.field - Char_Boss_Loop.mp3")
@export var fireball = preload("res://scenes/entity/projectile/fireball.tscn")

var start = false
var phase = 1

var phase1_init = false
var phase1_tracked = []
var wave_1_killed = false
var wave_2_killed = false
var wave_3_killed = false

func _ready() -> void:
	Bus.connect("on_boss_start", _on_boss_start)
	Bus.connect("on_party_kill", _on_party_kill)

func _process(_delta: float) -> void:
	if not start:
		return
		
	if start and not phase1_init:
		phase1_init = true
		_phase_1_init()
		return

func _on_boss_start():
	var audio = Global.player.get_node("AudioStreamPlayer")
	audio.stream = boss_music_no_vocal
	var timer = audio.get_node("Timer")
	timer.wait_time = boss_music_no_vocal.get_length()
	audio.play()
	start = true
	
func _on_party_kill(party):	
	if not start:
		return
		
	if phase != 1:
		return
	
	if not phase1_tracked.has(party):
		return
		
	phase1_tracked.erase(party)
	
	if phase1_tracked.is_empty():
		if not wave_1_killed:
			wave_1_killed = true
			_spawn_waves()
		elif not wave_2_killed:
			wave_2_killed = true
			_spawn_waves()
		elif not wave_3_killed:
			wave_3_killed = true
			var _fireball = fireball.instantiate()
			_fireball.position = position
			_fireball.velocity = Vector2.DOWN
			get_tree().current_scene.add_child(_fireball)
			phase += 1

func _phase_1_init():
	_spawn_waves()
	
func _spawn_waves():
	phase1_tracked.clear()
	
	var party: PackedScene = preload("res://scenes/spawner/party.tscn")
	var spawn_node1 = get_tree().current_scene.get_node("BossPhase1_PartySpawn")
	var party_instance1 = party.instantiate()
	party_instance1.position = spawn_node1.position
	party_instance1.has_captain = true
	party_instance1.entity_limit = 8
	phase1_tracked.append(party_instance1)
	get_tree().current_scene.add_child(party_instance1)
	var spawn_node2 = get_tree().current_scene.get_node("BossPhase1_PartySpawn2")
	var party_instance2 = party.instantiate()
	party_instance2.position = spawn_node2.position
	party_instance2.has_captain = true
	party_instance2.entity_limit = 8
	phase1_tracked.append(party_instance2)
	get_tree().current_scene.add_child(party_instance2)
	var spawn_node3 = get_tree().current_scene.get_node("BossPhase1_PartySpawn3")
	var party_instance3 = party.instantiate()
	party_instance3.position = spawn_node3.position
	party_instance3.has_captain = true
	party_instance3.entity_limit = 8
	phase1_tracked.append(party_instance3)
	get_tree().current_scene.add_child(party_instance3)
