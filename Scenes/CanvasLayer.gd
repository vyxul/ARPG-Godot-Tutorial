extends CanvasLayer

signal opened
signal closed

@onready var inventoryGUI = $InventoryGUI

# Called when the node enters the scene tree for the first time.
func _ready():
	inventoryGUI.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("inventory_toggle"):
		if (inventoryGUI.isOpen):
			inventoryGUI.close()
			closed.emit()
		else:
			inventoryGUI.open()
			opened.emit()
