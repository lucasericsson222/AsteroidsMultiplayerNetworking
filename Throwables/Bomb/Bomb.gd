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
