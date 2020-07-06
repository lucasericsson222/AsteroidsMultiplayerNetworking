extends VBoxContainer

var lobby_scene = preload("res://Lobby/Lobby.tscn")

func _on_CreateButton_pressed():
	
	network.server_info.name = $Server_Name_Input.text
	network.server_info.max_players = int($Max_Players_Input.text)
	network.server_info.used_port = int($Server_Port_Input.text)
	network.my_player_info.name = $Player_Name_Input.text
	network.my_player_info.color = $Color_Picker_Button.color
	if network.create_new_server():
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(lobby_scene)

	
