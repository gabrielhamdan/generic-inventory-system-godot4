class_name SlotGrid
extends GridContainer


@onready var children = get_children()

@export var _inventory: Inventory


func _ready():
	pass


func get_slots() -> Array[InventorySlot]:
	var slots: Array[InventorySlot]
	for child in children:
		var slot = child as InventorySlot
		slot.dragged.connect(_inventory.set_drag_item)
		slots.append(child)
	return slots
