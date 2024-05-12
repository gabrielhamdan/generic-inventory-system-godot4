extends Node2D


@onready var mouse_pos: Area2D = $MousePos


func _process(delta):
	mouse_pos.position = get_global_mouse_position()
