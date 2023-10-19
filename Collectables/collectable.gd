extends Area2D

@export var collectableType: String = "Collectable"
@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()

func getCollectableType() -> String:
	return collectableType
