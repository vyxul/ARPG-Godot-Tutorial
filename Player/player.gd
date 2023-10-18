extends CharacterBody2D

''' 
	Needs to do 3 things
	1. Get movement direction from input
	2. Set velocity to movement direction * speed
	3. Move player
'''

signal currentHealthChanged(currentHealth: int)

@export var speed: int = 50
@export var runSpeed: int = 100
@export var maxHealth: int = 12
@export var hit_iframes: int = 5
@export var dmg_taken_multiplier: int = 2

@onready var animations = $AnimationPlayer
@onready var hurtBoxTimer = $HurtBox/HurtBoxTimer
@onready var currentHealth: int = maxHealth

func _ready():
	hurtBoxTimer.wait_time = hit_iframes

func handleInput():
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	
	if (Input.is_action_pressed("space")):
		velocity = moveDirection * runSpeed
	else:
		velocity = moveDirection * speed
	
func updateAnimation():
	# If player stops moving, stop animation
	if (velocity.length() == 0):
		# Check if animation player is actually running
		if (animations.is_playing()):
			animations.stop()
	
	# Otherwise, player is moving and needs animation
	else:
		# Set default direction
		var direction = "Down"
		# Check for if different directions
		if   (velocity.x < 0): direction = "Left"
		elif (velocity.x > 0): direction = "Right"
		elif (velocity.y < 0): direction = "Up"
			
		# Set the correct animation based on the player direction
		animations.play("walk" + direction)
		
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
#		print_debug(collider.name)
		
func setCameraBounds(limit_left: int, limit_right: int, limit_top: int, limit_bottom: int):
	var camera = $Camera2D
	camera.limit_left = limit_left
	camera.limit_right = limit_right
	camera.limit_top = limit_top
	camera.limit_bottom = limit_bottom
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()
	# To keep player in bounds of screen, can do either clamp() here or place walls around map

func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		print_debug("Enemy Hit: %s" % area.get_parent().name)
		
		currentHealth -= round(1 * dmg_taken_multiplier)
		print_debug("currentHealth = %d" % currentHealth)
		
		# setting a cooldown timer for how many times player can be hit at a time
		currentHealthChanged.emit(currentHealth)
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		hurtBoxTimer.start(hit_iframes)
		
		
		if (currentHealth <= 0):
			currentHealth = maxHealth
			currentHealthChanged.emit(currentHealth)
	pass # Replace with function body.


func _on_hurt_box_timer_timeout():
	print_debug("HurtBox Timer timed out")
	# coming back from the hurtbox timer, enable the hurtbox again
	$HurtBox/CollisionShape2D.set_deferred("disabled", false)
	pass # Replace with function body.
