extends Node
signal mv_player(player_obj)
signal add_asteroids(id)
var player_resource = preload("res://Player/Player.tscn")
var menu_scene = preload("res://Menu/Multiplayer_Menu.tscn")
var game_scene = preload("res://Lobby/Lobby.tscn")
var server_info = {
	name = "Server",
	max_players = 0,
	used_port = 0
}

var my_player_info = {}

var player_info = {}

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")
	
	

func _on_player_connected(id: int):
	
	
	rpc_id(id, "register_player", my_player_info)
	print("_on_player_connected:     ")
	print(id, my_player_info.name)
	print("\n")
	

func _on_player_disconnected(id: int):
	player_info.erase(id)
	rpc("delete_other_player", id)
	
func _on_connected_to_server():
	get_tree().change_scene_to(game_scene)
	print("Connected to server")

func _on_connection_failed():
	print("Connection failed")
	
func _on_disconnected_from_server():
	print("Disconnected from server")
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(menu_scene)
	
func create_new_server():
	var net = NetworkedMultiplayerENet.new()
	var error = net.create_server(server_info.used_port, server_info.max_players)
	if error:
		print("Failed to create server")
		return false
		
	get_tree().set_network_peer(net)
	print("Server created Successfully")
	return true
	
func join_server(ip, port: int):
	var net = NetworkedMultiplayerENet.new()
	net.create_client(ip, port)
	
	get_tree().set_network_peer(net)
	print("Client Created Successfully")
	return true

remote func register_player(info):
	var id: int = get_tree().get_rpc_sender_id()
	player_info[id] = info
	var my_label = Label.new()
	my_label.text = String(id) + info.name
	add_child(my_label)
	print("func register_player:     ")
	print(info.name)
	
	var new_player = player_resource.instance()
	new_player.player_color = info.color
	new_player.name = String(id)

	
	add_child(new_player)
	emit_signal("mv_player", new_player)
	emit_signal("add_asteroids", id)

func create_own_player():
	var new_player = player_resource.instance()
	new_player.player_color = my_player_info.color
	new_player.name = String(get_tree().get_network_unique_id())
	add_child(new_player)
	emit_signal("mv_player", new_player)

remotesync func delete_other_player(id):
	for c in network.get_children():
		if c.name == String(id):
			c.queue_free()
