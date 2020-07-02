extends Sprite

onready var screen_size = get_viewport_rect().size
puppet var pos: Vector2 
puppet var rot = 0
var rot_speed = 10
var engine_speed = 200

var current_momentum = Vector2(0,0)
var player_color = Color.white

func _ready():
	self.modulate = player_color
	
func _process(delta):
	if (name == String(get_tree().get_network_unique_id())):
		var rot_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		var engine_input = int(Input.is_action_pressed("ui_up"))
		rpc_id(get_network_master(), "process_input", rot_input, engine_input, delta)
	if !is_network_master():
		position = pos
		rotation = rot
	else:
		rset("pos", position)
		rset("rot", rotation)

remotesync func process_input(rot_input, engine_input, delta):
	if !is_network_master():
		return
	rotation += rot_speed * delta * rot_input
	rset_unreliable("rot", rotation)
	
	var current_movement = Vector2(0, -engine_input)
	current_movement = current_movement.rotated(rotation).normalized()
	current_movement *= engine_speed * delta
	current_momentum += current_movement * delta
	position += current_momentum
	screen_wrap()
	rset_unreliable("pos", position)

func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
