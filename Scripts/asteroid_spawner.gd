extends Node2D

var asteroid_scene = preload("res://asteroid.tscn")

var id_counter = 0

func _ready():
	if is_network_master():
		create_asteroid(position, Color(1,0,0))
		create_asteroid(position, Color(0,1,0))

# warning-ignore:return_value_discarded
	network.connect("add_asteroids", self, "_on_player_connected")

func create_asteroid(pos, color):
	id_counter += 1
	rpc("create_client_asteroid", pos, id_counter, color)

remotesync func create_client_asteroid(pos, id, color):
	var new_asteroid = asteroid_scene.instance()
	new_asteroid.position = pos
	new_asteroid.id = id
	new_asteroid.name = String(id)
	new_asteroid.color = color
	add_child(new_asteroid)

func _on_player_connected(id):
	if is_network_master():
		for c in get_children():
			rpc_id(id, "create_client_asteroid", c.position, c.id, c.color)
