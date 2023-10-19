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
@export var knockbackTakenMultiplier: int = 1
@export var inventory: Inventory

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $HurtBox
@onready var hurtFXTimer = $Effects/hurtTimer
@onready var hurtBoxTimer = $HurtBox/HurtBoxTimer
@onready var weapon = $Weapon
@onready var currentHealth: int = maxHealth

var isHurt: bool = false
var lastAnimDirection: String = "Down"
var isAttacking: bool = false
var direction: String = "Down"

func _ready():
	hurtBoxTimer.wait_time = hit_iframes
	effects.play("RESET")
	weapon.visible = false
	weapon.disable()
	hurtFXTimer.wait_time = hit_iframes
	

func handleInput():
	var moveDirection = Input.get_vector("left", "right", "up", "down")
	
	if (Input.is_action_pressed("space")):
		velocity = moveDirection * runSpeed
	else:
		velocity = moveDirection * speed
		
	# Check for direction
	if   (velocity.x < 0): direction = "Left"
	elif (velocity.x > 0): direction = "Right"
	elif (velocity.y < 0): direction = "Up"
	elif (velocity.y > 0): direction = "Down"
	lastAnimDirection = direction
		
	if (Input.is_action_pressed("attack")):
		attack()
		
func attack():
	animations.play("attack" + lastAnimDirection)
	isAttacking = true
	weapon.enable()
	await animations.animation_finished
	weapon.disable()
	isAttacking = false
	
func updateAnimation():
	if isAttacking:
		return
	
	# If player stops moving, stop animation
	if (velocity.length() == 0):
		# Check if animation player is actually running
		if (animations.is_playing()):
			animations.stop()
	
	# Otherwise, player is moving and needs animation
	else:
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
	for area in hurtBox.get_overlapping_areas():
		if (area.name == "HitBox"):
			hurtByEnemy(area)
	# To keep player in bounds of screen, can do either clamp() here or place walls around map

func hurtByEnemy(area):
	if !isHurt:
		var enemy = area.get_parent()
	#	print_debug("Enemy Hit: %s" % enemy.name)
		var enemy_dmg_given = enemy.get_damage()
	#	print_debug("Enemy Damage Given: %d" % enemy_dmg_given)
		
		currentHealth -= round(enemy_dmg_given * dmg_taken_multiplier)
	#	print_debug("currentHealth = %d" % currentHealth)
		
		# setting a cooldown timer for how many times player can be hit at a time
		currentHealthChanged.emit(currentHealth)
		
		# disabling the collisionshape2d doesnt work as well since we won't be able
		# to pick up items while invulnerable
		# better to use a flag like with "isHurt"
#		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
#		hurtBoxTimer.start(hit_iframes)
		isHurt = true
		
		if (currentHealth < 0):
			currentHealth = maxHealth
			currentHealthChanged.emit(currentHealth)
			
		knockback(enemy.position, enemy.knockbackPower)
		effects.play("hurtBlink")
		hurtFXTimer.start()
		await hurtFXTimer.timeout
		effects.play("RESET")
		isHurt = false

func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		hurtByEnemy(area)
	
	if area.has_method("collect"):
		area.collect(inventory)
#		print_debug("Collectable type: %s" % area.getCollectableType())

func _on_hurt_box_timer_timeout():
#	print_debug("HurtBox Timer timed out")
	# coming back from the hurtbox timer, enable the hurtbox again
#	$HurtBox/CollisionShape2D.set_deferred("disabled", false)
	# doing the solution that uses flag instead
	pass

func knockback(enemyPosition: Vector2, enemyknockbackPower: int):
	# Does the knockback based on the enemy position compared to player position
#	print_debug("enemyPosition: %s, knockbackPower: %d, position: %s"
#	 			% [str(enemyPosition), knockbackPower, str(position)])
	var knockbackDirection = (position - enemyPosition).normalized() * enemyknockbackPower * knockbackTakenMultiplier
	velocity = knockbackDirection
	move_and_slide()
#	print_debug("enemyPosition: %s, knockbackPower: %d, position: %s" % [str(enemyPosition), knockbackPower, str(position)])


