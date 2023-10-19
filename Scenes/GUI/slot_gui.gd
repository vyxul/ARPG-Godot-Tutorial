extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if !slot:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amountLabel.visible = false
		
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		
		var itemAmount = slot.amount
		if (itemAmount > 1):
			amountLabel.visible = true
			amountLabel.text = str(itemAmount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
