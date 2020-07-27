extends Position2D

var player_scene = load("res://Player/Player.tscn")

puppet var countdown = 10

var dead_player = ""

var dead_color = Color.white




func _process(delta):
	if(is_network_master()):
		rset("countdown", int($Death_Respawn_Timer.time_left))
		countdown = int($Death_Respawn_Timer.time_left)
	
	$Label.text = String(countdown + 1)
	

remotesync func create_player(new_pos, new_name, new_color):
	if (new_name == ""):
		queue_free()
		return
	var new_player = player_scene.instance()
	new_player.position = new_pos
	new_player.name = new_name
	new_player.player_color = new_color
	get_parent().add_child(new_player)
	queue_free()


func _on_Death_Respawn_Timer_timeout():
	if(is_network_master()):
		rpc("create_player", position, dead_player, dead_color)
