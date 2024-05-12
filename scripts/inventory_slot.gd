class_name InventorySlot
extends PanelContainer


signal dragged

const STACK_COUNTER_LABEL: String = "x%d"
const TOP_ICON_POS: float = 0
const ORIGIN_ICON_POS: float = 10.0
const HIGHLIGHT_SPEED: float = 200.0

@onready var item_icon: TextureRect = $MarginContainer/ItemIcon
@onready var item_counter: Label = $MarginContainer/ItemCounter

@export var slot_area: SlotArea

var index: int
var stack_counter: int = 0
var current_item: Item
var inventory: Inventory
var should_highlight_item: bool


func _ready():
	index = get_index()
	slot_area.slot_index = index


func _process(delta):
	highlight_item(delta)


func highlight_item(delta: float):
	if should_highlight_item and current_item != null:
		item_icon.position.y = move_toward(item_icon.position.y, TOP_ICON_POS, delta * HIGHLIGHT_SPEED)
	elif not should_highlight_item and current_item != null:
		item_icon.position.y = move_toward(item_icon.position.y, ORIGIN_ICON_POS, delta * HIGHLIGHT_SPEED)


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_action"):
		emit_signal("dragged", index, current_item, stack_counter)
		free_slot()
	elif event.is_action_pressed("mouse_option"):
		remove_item()


func is_slot_empty() -> bool:
	return current_item == null


func remove_item():
	if not is_slot_empty():
		get_tree().call_group("inventory", "remove_item")
		update_slot(current_item, -1)


func free_slot():
	current_item = null
	item_icon.texture = null
	item_counter.text = ""
	stack_counter = 0


func update_slot(item: Item, qt: int):
	stack_counter += qt
	current_item = item
	
	if stack_counter > 0:
		var icon_texture = load(current_item.item_icon_path)
		item_icon.texture = icon_texture
		item_counter.text = STACK_COUNTER_LABEL % stack_counter
	else:
		free_slot()


func _on_area_2d_area_entered(_area):
	should_highlight_item = true


func _on_area_2d_area_exited(_area):
	should_highlight_item = false
