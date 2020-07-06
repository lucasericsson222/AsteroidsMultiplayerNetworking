extends VBoxContainer

var lobby_scene = preload("res://Lobby/Lobby.tscn")


func _on_JoinButton_pressed():
	var server_address = $Server_Address_Input.text
	var port := int($Server_Port_Input.text)
	network.my_player_info.name = $Player_Name_Input.text
	network.my_player_info.color = $Color_Picker_Button.color
	network.join_server(server_address, port)
	get_tree().change_scene_to(lobby_scene)
	
