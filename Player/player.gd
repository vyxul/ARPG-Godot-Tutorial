extends CharacterBody2D

''' 
	Needs to do 3 things
	1. Get movement direction from input
	2. Set velocity to movement direction * speed
	3. Move player
'''

@export var speed: int = 35

func handleInput():
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	velocity = moveDirection * speed
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
