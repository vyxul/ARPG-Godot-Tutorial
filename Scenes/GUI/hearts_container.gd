extends HBoxContainer


@onready var heartGuiClass = preload("res://Scenes/GUI/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(maxHP: int):
	# Create hearts until no more are needed
	var currentHPMade = 0
#	print_debug("currentHPMade = %d" % currentHPMade)
	
	while (currentHPMade < maxHP):
		var heart = heartGuiClass.instantiate()
		currentHPMade += heart.healthPerHeart
		add_child(heart)
#		print_debug("currentHPMade = %d" % currentHPMade)
		
func updateHearts(currentHealth: int):
#	print_debug("currentHealth: %d" % currentHealth)
	var hearts = get_children()
	var healthPerHeart = hearts[0].healthPerHeart
	
	var heartsToUpdate = hearts.size()
	var heartsUpdated = 0
	var maxHP = healthPerHeart * heartsToUpdate
	var hpToUpdate = currentHealth
	
#	print_debug("heartsToUpdate: %d, heartsUpdated: %d, maxHP: %d, hpToUpdate: %d" % [heartsToUpdate, heartsUpdated, maxHP, hpToUpdate])
#	print_debug("Going into first loop")
	
	# Update the hearts that still have hp
	while (hpToUpdate > 0):
#		print_debug("hpToUpdate: %d" % hpToUpdate)
		if (hpToUpdate >= healthPerHeart):
			hearts[heartsUpdated].update(healthPerHeart)
		else:
			hearts[heartsUpdated].update(hpToUpdate % healthPerHeart)
		
		heartsUpdated += 1
		hpToUpdate -= healthPerHeart

#	print_debug("heartsToUpdate: %d, heartsUpdated: %d, maxHP: %d, hpToUpdate: %d" % [heartsToUpdate, heartsUpdated, maxHP, hpToUpdate])		
#	print_debug("Going into second loop")
		
	# If there are any extra hearts without hp, set to empty
	while (heartsUpdated < heartsToUpdate):
#		print_debug("heartsUpdated: %d" % heartsUpdated)
		hearts[heartsUpdated].update(0)
		heartsUpdated += 1
