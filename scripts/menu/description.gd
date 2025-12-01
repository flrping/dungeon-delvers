extends Control

@onready var label = $Label

var meredith_text = """
I’m only going to say this once so listen closely.
The Golden Dragon of Carcosa has been discovered. After years of searching, my Seers have divined his location, He is held in the caves below Mount Tremboragg. 

Kill anything that isn’t him, and bring him home.

Some of your old compatriots were recently captured. I’m sending them on this suicide mission with you because they won’t answer to me.

Accomplish this, and I will move you to a better cell.
"""

var ryon_text = """
The Paladin of Fathomir himself graces me with his presence. 

It’s good to see you again friend.

I will tell you why I have sent for you.

The Golden Dragon of Carcosa has been discovered. After years of searching, my Seers have divined his location, He is held in the caves below Mount Tremboragg. 

I see you’ve brought with you mages from your land. Feel free to take them with you on this quest for reinforcements. For the fight will be perilous.

If you see Jasper tell him I forgive him for what he did.
"""

var timer = 0.0

func _ready() -> void:
	if Global.player_name.to_lower() == "meredith":
		label.text = meredith_text
	else:
		label.text = ryon_text

func _process(delta: float) -> void:
	timer += delta
	
	if timer > 10.0:
		get_tree().change_scene_to_file("res://scenes/stage/stage.tscn")
