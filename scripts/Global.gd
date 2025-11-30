extends Node

var objectives: Dictionary[Variant, Variant] = {
	"1": {
		"name": "capture_intersections",
		"prompt": "Capture both intersections to open the gates to the fortress!",
		"related": ["Central Intersection East", "Central Intersection West"],
		"type": "capture",
		"on_complete": ["res://scripts/objectives/capture_intersections.gd"]
	},
	"2": {
		"name": "capture_fortress_entrance_west",
		"prompt": "Fortress Entrance West seems to have the key to the Fortress Storage, get it!",
		"related": ["Fortress Entrance West"],
		"type": "capture",
		"on_complete": ["res://scripts/objectives/capture_fortress_entrance.gd"]
	},
	"3": {
		"name": "capture_fortress_storage",
		"prompt": "The Fortress Storage West seems to keep keys to the Hall, get it!",
		"related": ["Fortress Storage"],
		"type": "capture",
		"on_complete": ["res://scripts/objectives/capture_fortress_storage.gd"]
	},
	"4": {
		"name": "capture_fortress_hall",
		"prompt": "The enemy is noticing you! Capture the hall!",
		"related": ["Fortress Hall"],
		"type": "capture",
		"on_complete": ["res://scripts/objectives/capture_fortress_hall.gd"]
	},
	"5": {
		"name": "capture_fortress_headquarters",
		"prompt": "Finish them off! To the headquarters!",
		"related": ["Fortress Headquarters"],
		"type": "capture",
		"on_complete": ["res://scripts/objectives/capture_fortress_headquarters.gd"]
	},
	"6": {
		"name": "kill_dragon",
		"prompt": "There seems to be something else here.",
		"related": ["DragonBoss"],
		"type": "kill",
		"on_complete": ["res://scripts/objectives/dragon_kill.gd"]
	}
}

var player
var player_ui
var is_cutscene_playing = false
var objective_index: int = 1
var current_objective = objectives[str(objective_index)]
var objective_related_nodes: Array[Node] = []
var player_name: String = "Meredith"
var player_color: String = "ff7b17"
var kills: int = 0

func init():
	kills = 0

func _next_objective() -> void:
	objective_index += 1
	if objectives.has(str(objective_index)):
		current_objective = objectives[str(objective_index)]
		objective_related_nodes.clear()
		
		_setup_objective()
		Bus.emit_signal("on_new_objective", current_objective)

func _setup_objective() -> void:
	for node_name in current_objective["related"]:
		var node: Node = get_tree().current_scene.get_node_or_null(node_name)
		if node:
			objective_related_nodes.append(node)
			
func _notify(text: String, seconds: float):
	var obj_label = player_ui.get_node("Objective Label")
	var timer: SceneTreeTimer = get_tree().create_timer(seconds)
	obj_label.text = text
	obj_label.visible = true
	
	await timer.timeout
	obj_label.visible = false
