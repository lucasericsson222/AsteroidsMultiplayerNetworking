extends Node2D

var spawn_locations
var rng = RandomNumberGenerator.new()
func _ready():
# warning-ignore:return_value_discarded
	network.connect("mv_player", self, "_on_mv_player")
	spawn_locations = get_children()
	rng.randomize()
	
func _on_mv_player(player):
	var chosen_location = rng.randi_range(0, get_child_count()-1)
	player.position = spawn_locations[chosen_location].position
	print("_on_mv_player")

