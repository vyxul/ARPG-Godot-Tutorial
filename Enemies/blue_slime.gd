extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var on_hit_dmg: int = 2
@export var knockbackPower: int = 250

@onready var animations = $AnimationPlayer

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	
func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVelocity():
	var moveDirection = (endPosition - position)
	if (moveDirection.length() < limit):
		changeDirection()
		
	velocity = moveDirection.normalized() * speed
	
func updateAnimation():
	# making the left and right animations take priority
	var animationString = "walkUp"
	if (velocity.y > 0):
		animationString = "walkDown"
	if (velocity.x < 0):
		animationString = "walkLeft"
	if (velocity.x > 0):
		animationString = "walkRight"
		
	animations.play(animationString)
	
func get_damage_given() -> int:
	return on_hit_dmg
	
func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
