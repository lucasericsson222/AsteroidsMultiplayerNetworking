extends VBoxContainer

var game_scene = preload("res://game_root.tscn")

func _on_CreateButton_pressed():
	
	network.server_info.name = $ServerNameInput.text
	network.server_info.max_players = int($MaxPlayersInput.text)
	network.server_info.used_port = int($ServerPortInput.text)
	network.my_player_info.name = $PlayerNameInput.text
	network.my_player_info.color = $ColorPickerButton.color
	network.create_new_server()
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(game_scene)

	
