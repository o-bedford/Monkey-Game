extends ParallaxBackground

func _ready():
	pass
	
func _process(delta):
	scroll_offset.x += 1000 * delta
