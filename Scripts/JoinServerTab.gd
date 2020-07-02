extends VBoxContainer

var game_scene = preload("res://game_root.tscn")


func _on_JoinButton_pressed():
	var server_address = $ServerAddressInput.text
	var port := int($ServerPortInput.text)
	network.my_player_info.name = $PlayerNameInput.text
	network.my_player_info.color = $ColorPickerButton.color
	network.join_server(server_address, port)
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(game_scene)
	
