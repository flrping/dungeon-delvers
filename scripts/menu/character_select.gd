extends Control

@onready var meredith: TextureRect = $Meredith
@onready var meredith_select: TextureRect = $MeredithSelect
@onready var meredith_splash: TextureRect = $MeredithSplash
@onready var meredith_theme = preload("res://assets/tracks/xia.field - Char_Meredith.mp3")
@onready var ryon: TextureRect = $Ryon
@onready var ryon_select: TextureRect = $RyonSelect
@onready var ryon_splash: TextureRect = $RyonSplash
@onready var ryon_theme = preload("res://assets/tracks/xia.field - Char_Ryon.mp3")
@onready var marjorie: TextureRect = $Marjorie
@onready var marjorie_select: TextureRect = $MarjorieSelect
@onready var marjorie_splash: TextureRect = $MarjorieSplash
@onready var marjorie_theme = preload("res://assets/tracks/xia.field - Char_Marjorie.mp3")
@onready var jade: TextureRect = $Jade
@onready var jade_select: TextureRect = $JadeSelect
@onready var jade_splash: TextureRect = $JadeSplash
@onready var jade_theme = preload("res://assets/tracks/xia.field - Char_Jade.mp3")

@onready var description: Label = $Descriptions
@onready var audio = $AudioStreamPlayer

var index: int = 0

func _ready() -> void:
	_set_details()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Right"):
		index += 1
		if index > 3:
			index = 0
		_set_details()
	elif event.is_action_pressed("Left"):
		index -= 1
		if index < 0:
			index = 3
		_set_details()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("Light_Attack"):
		match index:
			0:
				Global.player_name = "Meredith"
				Global.player_color = "ff7b17"
			1:
				Global.player_name = "Ryon"
				Global.player_color = "73efe8"
			2:
				Global.player_name = "Marjorie"
				Global.player_color = "751106"
			3:	
				Global.player_name = "Jade"
				Global.player_color = "1bbe42"
			
		get_tree().change_scene_to_file("res://scenes/menu/description.tscn")
	
func _set_details():
	if index == 0:
		meredith_select.visible = true
		ryon_select.visible = false
		marjorie_select.visible = false
		jade_select.visible = false
		description.text = "Meredith: Vanquished Tyrant, former leader of a group of Anti-Magic Militants known as the Inquisitors. Wields a blade rumored to be a shard of Magic itself. Dragonrider of Fenrir The Devourer, Cunning and Arrogant."
		meredith_splash.visible = true
		ryon_splash.visible = false
		marjorie_splash.visible = false
		jade_splash.visible = false
		audio.stream = meredith_theme
	elif index == 1:
		meredith_select.visible = false
		ryon_select.visible = true
		marjorie_select.visible = false
		jade_select.visible = false
		description.text = "Ryon deflects magic attacks if hes facing them and if they hit him he takes double damage.\n\n Ryon: Faithful Orca-Man servant of Fathomir, God of the Ocean. Second in line for the Prismitoran Throne and King of The Northern Lands. A famed hero and respected Paladin."
		meredith_splash.visible = false
		ryon_splash.visible = true
		marjorie_splash.visible = false
		jade_splash.visible = false
		audio.stream = ryon_theme
	elif index == 2:
		meredith_select.visible = false
		ryon_select.visible = false
		marjorie_select.visible = true
		jade_select.visible = false
		description.text = "Marjorie: Retired adventurer and Accomplished Archmage. Personal friend of the God of Magic, Distantly related to a “The Devourer”, a Powerful and fearsome Dragon. Specializes in lightning magic, Intelligent and Kind."
		meredith_splash.visible = false
		ryon_splash.visible = false
		marjorie_splash.visible = true
		jade_splash.visible = false
		audio.stream = marjorie_theme
	else:
		meredith_select.visible = false
		ryon_select.visible = false
		marjorie_select.visible = false
		jade_select.visible = true
		description.text = "In a bid to bring back that which was no more, a Dark Magic ritual was performed, someone was lost, someone was gained, or perhaps the two were both restored. One cannot be certain."
		meredith_splash.visible = false
		ryon_splash.visible = false
		marjorie_splash.visible = false
		jade_splash.visible = true
		audio.stream = jade_theme
	
	audio.play()
