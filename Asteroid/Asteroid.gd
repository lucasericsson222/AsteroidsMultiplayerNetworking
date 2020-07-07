extends Sprite

var id

puppet var rot = 0
puppet var pos = Vector2(0,0)
var rot_speed = rand_range(1,6)
var movement_speed = rand_range(150, 500)
var start_rot = rand_range(0, 2 * PI)
puppet var color = Color(1,1,1)

enum states {
	ROAMING,
	GRABBED
}
var state = states.ROAMING
var grabbing_player_name = ""
func _ready():
	signal_emitter.connect("not_grabbing", self, "_on_not_grabbing")
	
	randomize()
	if !is_network_master():
		rotation = rot
		position = pos
	else:
		rotation = start_rot
		rset("rot",rotation )
		rset("pos", position)

func _process(delta):
	modulate = color
	if !is_network_master():
		rotation = rot
		position = pos

	else:
		if grabbing_player_name == "":
			state = states.ROAMING
		else:
			state = states.GRABBED
			
		if state == states.ROAMING:
			var new_movement = Vector2(0,1).rotated(start_rot).normalized() * movement_speed
			position += new_movement * delta
		elif state == states.GRABBED:
			var path = "/root/network/" + grabbing_player_name + "/Asteroid_Holding_Position"
			position = get_node(path).global_position
			rset("color", color)
			
		screen_wrap()
		rotation += rot_speed * delta
		rset("pos", position)
		rset("rot", rotation)

onready var screen_size = get_viewport_rect().size

func screen_wrap():
	position.x = wrapf(position.x, -50, screen_size.x + 50)
	position.y = wrapf(position.y, -50, screen_size.y + 50)


func _on_not_grabbing(player_name, dir, throw_speed):
	if (grabbing_player_name == player_name):
		grabbing_player_name = ""
		movement_speed = throw_speed
		start_rot = dir + PI
