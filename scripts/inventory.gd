class_name Inventory
extends Control


const DRAGGABLE_ICON_SCN_PATH = "res://scenes/draggable_icon.tscn"
const PICK_ITEM_SFX_PATH = "res://assets/sfx/switch2.ogg"
const SWAP_ITEM_SFX_PATH = "res://assets/sfx/switch32.ogg"
const SWAP_ITEMS_SFX_PATH = "res://assets/sfx/switch38.ogg"
const REMOVE_ITEM_SFX_PATH = "res://assets/sfx/rollover1.ogg"

@onready var slot_grid: GridContainer = $SlotGrid
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@export var mockup_items: Array[Item]
@export var mouse_pos: Marker2D
@export var mouse_area: Area2D
@export var draggable: Draggable

var slots: Array[InventorySlot]
var is_mouse_action_pressed: bool = false
#var slot_index_to_mouse_pos: int


func _ready():
	slots = slot_grid.get_slots()


func _process(_delta):
	mouse_pos.position = get_global_mouse_position()
	mouse_area.position = get_global_mouse_position()
	drag_item()


func _input(event: InputEvent):
	if event.is_action_pressed("mouse_action"):
		is_mouse_action_pressed = true
	elif  event.is_action_released("mouse_action"):
		is_mouse_action_pressed = false


func add_item(new_item: Item):
	var first_empty_slot = -1
	for slot in slots:
		if first_empty_slot < 0 and slot.current_item == null:
			first_empty_slot = slot.index
		if slot.current_item != null and slot.current_item.item_name == new_item.item_name and slot.stack_counter < new_item.max_stack_count:
			slot.update_slot(new_item, 1)
			return
	if first_empty_slot >= 0:
		slots[first_empty_slot].update_slot(new_item, 1)


func remove_item():
	audio_player.stream = load(REMOVE_ITEM_SFX_PATH)
	audio_player.play()


func swap_item():
	var draggable_icon = mouse_pos.get_child(0) as DraggableIcon
	
	var new_slot_index = draggable_icon.current_index
	var previous_slot_index = draggable._slot_index
	
	if new_slot_index < 0:
		new_slot_index = draggable._slot_index
	
	audio_player.stream = load(SWAP_ITEM_SFX_PATH)
	if previous_slot_index != new_slot_index:
		if slots[new_slot_index].current_item != null:
			audio_player.stream = load(SWAP_ITEMS_SFX_PATH)
		slots[previous_slot_index].update_slot(slots[new_slot_index].current_item, slots[new_slot_index].stack_counter)
		slots[new_slot_index].free_slot()
	audio_player.play()
	slots[new_slot_index].update_slot(draggable._item, draggable._stack_counter)
	draggable._item = null

	draggable_icon.queue_free()


func set_drag_item(slot_index: int, item: Item, stack_counter: int):
	if item != null:
		draggable.draggable(slot_index, item, stack_counter)


func drag_item():
	if is_mouse_action_pressed and draggable._item != null and mouse_pos.get_child_count() == 0:
		audio_player.stream = load(PICK_ITEM_SFX_PATH)
		audio_player.play()
		var scene = load(DRAGGABLE_ICON_SCN_PATH) as PackedScene
		var instance = scene.instantiate() as DraggableIcon
		instance.item_icon_path = draggable._item.item_icon_path
		instance.current_index = draggable._slot_index
		mouse_pos.add_child(instance)
	elif not is_mouse_action_pressed and draggable._item != null:
		swap_item()


func _on_button_pressed():
	var rand = randi() % mockup_items.size()
	add_item(mockup_items[rand])
