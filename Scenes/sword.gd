extends Area2D

@export var dmg: int = 1
@export var knockbackPower: int = 250

@onready var shape = $CollisionShape2D

func enable():
	shape.disabled = false
	
func disable():
	shape.disabled = true
	
func get_damage() -> int:
	return dmg
