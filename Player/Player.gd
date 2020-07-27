extends Sprite

var death_scene = preload("res://Player_Death/Player_Death.tscn")


onready var screen_size = get_viewport_rect().size
puppet var pos: Vector2 
puppet var rot = 0
var rot_speed = 10
var engine_speed = 400
var throw_speed = 600
var current_momentum = Vector2(0,0)
var player_color = Color.white
var has_asteroid = false
var throw_recoil = 25
var asteroid_script = preload("res://Asteroid/Asteroid.gd")
func _ready():
	self.modulate = player_color
	
func _process(delta):
	if (name == String(get_tree().get_network_unique_id())):
		var rot_right_input = int(Input.is_action_pressed("game_right"))
		var rot_left_input = (Input.is_action_pressed("game_left"))
		var engine_input = int(Input.is_action_pressed("game_up"))
		var grab_input = Input.is_action_pressed("game_grab")
		rpc_id(get_network_master(), "process_input", rot_right_input, rot_left_input, engine_input,grab_input, delta)
	if !is_network_master():
		position = pos
		rotation = rot
	else:
		rset("pos", position)
		rset("rot", rotation)


remotesync func process_input(rot_right_input, rot_left_input, engine_input, grab_input, delta):
	if !is_network_master():
		return
	$Asteroid_Holding_Position.rotation = rotation
	if rot_right_input:
		rotation += rot_speed * delta 
	if rot_left_input:
		rotation -= rot_speed * delta
	rset_unreliable("rot", rotation)
	if (engine_speed < 0): 
		var current_movement = Vector2(0, -1)
		current_movement = current_movement.rotated(rotation).normalized()
		current_movement *= engine_speed * delta * throw_recoil
		engine_speed = -engine_speed
		current_momentum += current_movement * delta
	else:
		var current_movement = Vector2(0, -engine_input)
		current_movement = current_movement.rotated(rotation).normalized()
		current_movement *= engine_speed * delta
		current_momentum += current_movement * delta
	position += current_momentum
	screen_wrap()
	rset_unreliable("pos", position)                        
	if grab_input and !has_asteroid:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(self.position, Vector2(0,-1000000).rotated(self.rotation), [$KinematicBody2D])
		if !result.empty():
			link_asteroid(result)
	elif has_asteroid and !grab_input:
		signal_emitter.emit_signal("not_grabbing", name, rotation, throw_speed)
		has_asteroid = false

func screen_wrap():
	position.x = wrapf(position.x, -50, screen_size.x+50)
	position.y = wrapf(position.y, -50, screen_size.y+50)


func link_asteroid(result):
	var collision = result["collider"].get_parent()
	if(collision is asteroid_script):
		collision.grabbing_player_name = name
		collision.color = player_color
		has_asteroid = true


func _on_death():
	var death = death_scene.instance()
	death.dead_player = name
	death.position = position
	death.dead_color = player_color
	get_parent().add_child(death)
	queue_free()
	


func _on_KinematicBody2D_body_entered(body):
	_on_death()
