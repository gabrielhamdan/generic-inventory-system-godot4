class_name DraggableIcon
extends MarginContainer


const NULL_INDEX = -1

@onready var item_icon: TextureRect = $TextureRect
@onready var debug_index: Label = $DebugIndex

var item_icon_path: String
var current_index: int


func _ready():
	item_icon.texture = load(item_icon_path)


func _process(_delta):
	debug_index.text = str(current_index)


func _on_area_2d_area_entered(area):
	if area is SlotArea:
		if area.get_slot_index() != current_index:
			current_index = area.get_slot_index()


func _on_area_2d_area_exited(area):
	if area is SlotArea:
		if area.get_slot_index() == current_index:
			current_index = NULL_INDEX
