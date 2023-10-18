extends Panel

@export var healthPerHeart: int = 4

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(num: int):
#	print_debug("num: %d" % num)
	sprite.frame = 4 - num
