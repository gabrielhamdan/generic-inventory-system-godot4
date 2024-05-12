extends Node2D


const MAX_REPEL_DISTANCE: float = 25.0

@onready var sprite: Sprite2D = $Sprite2D

var should_repel: bool = false
var repel_speed = 250.0
var current_repel_direction: Vector2


func _process(delta):
	repel(delta)


func repel(delta):
	if should_repel:
		var repel_direction = (position - get_global_mouse_position()).normalized()
		var new_pos = repel_direction * delta * repel_speed
		if (sprite.position + new_pos).distance_to(position) < MAX_REPEL_DISTANCE:
			sprite.position += new_pos
	elif not should_repel and sprite.position != position:
		var origin_direction = (sprite.position - position).normalized()
		sprite.position -= origin_direction * delta * repel_speed
		if sprite.position.distance_to(position) < 1:
			sprite.position = position


func _on_area_entered(area):
	should_repel = true


func _on_area_exited(area):
	should_repel = false
