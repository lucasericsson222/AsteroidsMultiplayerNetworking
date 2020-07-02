extends ColorPickerButton

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	self.color = Color.from_hsv(rng.randf_range(0.0,1.0), 1.0, 1.0)
