extends Area2D

const MIN_TIME = 2.0
const TIME_TO_ADD = 0.05

var dragon
var dragon_head
var dragon_left_arm
var dragon_right_arm
var dragon_dialogue
var boss_music: AudioStreamMP3 = load("res://assets/tracks/xia.field - Char_Boss.mp3")

var is_playing = false
var lines: Array[String] = [
	"Brave Adventurer:Burax Adventuros",
	"Dungeon delver.:Denos Dylvir",
	"Have you come here to save me?:Hur Ix Cairn hyr tu san Mix?",
	"If that is your intention,:If den ixt orr cintrenax",
	"I Fear you are too late.",
	"I have resisted far too long.",
	"But the magic has taken a grasp on my soul.",
	"I am sorry for what is to become of you",
	]
	
var dialogue_lengths: = [
	2.3,
	3.0,
	1.1,
	1.4,
	2.5,
	2.0,
	2.0,
	2.5,
	8.0,
	2.5,
	1.0,
	2.0,
	5.0,
	3.0,
	5.7,
	3.0
	]

func _ready() -> void:
	dragon = get_tree().current_scene.get_node_or_null("DragonBoss")
	dragon_head = dragon.get_node("BossHeadFrames")
	dragon_left_arm = dragon.get_node("BossLeftArmFrames")
	dragon_right_arm = dragon.get_node("BossRightArmFrames")
	dragon_dialogue = dragon.get_node("Dialogue")

func _on_body_entered(_body: Node2D) -> void:
	if is_playing:
		return
		
	is_playing = true
	var audio = Global.player.get_node("AudioStreamPlayer")
	audio.stream = boss_music
	var timer = audio.get_node("Timer")
	timer.wait_time = boss_music.get_length()
	audio.play()
	
	await run_cutscene()
	
	Bus.emit_signal("on_boss_start")
	queue_free()

func run_cutscene():
	var dialogue_index := 0

	for i in range(lines.size()):
		match i:
			3: _save_me()
			4: _intention()
			5: _too_late()
			7: _sorry()
			_: pass
			
		var delay_before = dialogue_lengths[dialogue_index * 2]
		var speak_duration = dialogue_lengths[dialogue_index * 2 + 1]
		
		dragon_head.stop()
		print(delay_before)
		await get_tree().create_timer(delay_before).timeout
		_display(dialogue_index, speak_duration)
		dragon_head.play()
		await get_tree().create_timer(speak_duration).timeout
		dragon_head.stop()
		dialogue_index += 1

func _display(index: int, time: float) -> void:
	var _lines := lines[index].split(":")
	if _lines.size() > 1:
		_notify(_lines.get(0) + "\n\n [color='#ff0000']" + _lines.get(1) + "[/color]", time)
	else:
		_notify(_lines.get(0), time)
	
func _save_me():
	dragon_head.play("look_left")
	dragon_head.position.x = -16
	dragon_head.position.y = -38.8
	dragon_head.frame = 1
	
func _intention():
	dragon_head.play()
	
func _too_late():
	dragon_head.play("look_center")
	dragon_head.position.x = -5.6
	dragon_head.position.y = -39.6
	dragon_left_arm.visible = true
	dragon_right_arm.visible = true

func _sorry():
	dragon_head.play("look_right")
	dragon_head.position.x = 3.2
	dragon_head.position.y = -39.6
	
func _notify(text: String, seconds: float):
	var timer: SceneTreeTimer = get_tree().create_timer(seconds)
	dragon_dialogue.text = text
	dragon_dialogue.visible = true
	
	await timer.timeout
	dragon_dialogue.visible = false
