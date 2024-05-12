class_name Draggable
extends Resource


var _slot_index: int
var _item: Item
var _stack_counter: int


func draggable(slot_index: int, item: Item, stack_counter: int):
	_slot_index = slot_index
	_item = item
	_stack_counter = stack_counter
