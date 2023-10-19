extends CharacterBody2D

@export var hp = 5
@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D
@export var dmg: int = 2
@export var hit_iframes: int = 1
@export var knockbackPower: int = 250
@export var knockbackTakenMultiplier: int = 2

@onready var animations = $AnimationPlayer
@onready var effects = $Effects
@onready var hurtFXTimer = $Effects/hurtTimer

var startPosition
var endPosition
var isHurt: bool = false
var beingKilled: bool = false

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	hurtFXTimer.wait_time = hit_iframes
	effects.play("RESET")
	$deathEffect.visible = false
	
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
	
func get_damage() -> int:
	return dmg
	
func _physics_process(delta):
	if beingKilled:
		return
		
	updateVelocity()
	move_and_slide()
	updateAnimation()

func hurtByEnemy(area):
	if isHurt || beingKilled:
		return
	
	var dmg_taken = area.get_damage()
	hp -= dmg_taken
	print_debug("slime hit by %s with dmg of %d, slime hp: %d" % [area.name, dmg_taken, hp])

	# If slime dies	
	if (hp <= 0):
		$HitBox.set_deferred("monitorable", false)
		beingKilled = true
		animations.play("deathAnimation")
		await animations.animation_finished
		queue_free()
		
	# If slime doesnt die
	else:
		# Get position of player, not weapon and knockback
		var enemyPosition = area.get_parent().get_parent().position
		var enemyKnockbackPower = area.knockbackPower
		knockback(enemyPosition, enemyKnockbackPower)
		
		# Do the hit animation
		isHurt = true
		effects.play("hurtBlink")
		hurtFXTimer.start()
		await hurtFXTimer.timeout
		effects.play("RESET")
		isHurt = false
		
func knockback(enemyPosition: Vector2, enemyknockbackPower: int):
	# Does the knockback based on the enemy position compared to player position
	var knockbackDirection = (position - enemyPosition).normalized() * enemyknockbackPower * knockbackTakenMultiplier
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_entered(area):
	# Avoid the enemy from hitting their own hitbox
	if (area == $HitBox):
		return
	
	if (area.get_parent().get_parent().name == "Player"):
		hurtByEnemy(area)
