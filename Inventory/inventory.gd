extends Resource
class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	# Look to see if that item exists in inventory already
	for slot in slots:
		if (slot):
			if (slot.item == item):
				if (slot.amount < slot.maxAmountStack):
					slot.amount += 1

					updated.emit()
					return

	# Item not yet in inventory, put it in first empty slot
	for i in range(slots.size()):
		if (!slots[i]):
			slots[i] = InventorySlot.new()
			slots[i].item = item
			slots[i].amount = 1
			slots[i].maxAmountStack = item.maxAmountStack

			updated.emit()
			return


#	# Another implementation to the above code
#   # Don't have it working yet, did it different from video
#	var itemSlots = slots.filter(
#		func(slot):
#			return slot.item == item
#	)
#	if !itemSlots.is_empty():
#		itemSlots[0].amount += 1
#
#	else:
#		var emptySlots = slots.filter(
#			func(slot):
#				return slot.item == null
#		)
#		if !emptySlots.is_empty():
#			emptySlots[0].item = item
#			emptySlots[0].amount = 1
#
#	updated.emit()
