extends Node2D

@onready var tile_map = $"../Ground"
@onready var player = $"../Player"

var cell_size: Vector2 = Vector2(64, 64)
var destination

func _ready() -> void:
	player.connect("destination_updated", Callable(self, "_on_destination_updated"))

func _on_destination_updated(new_destination):
	destination = new_destination
	print("New destination:", destination)
	queue_redraw()
	
func _draw() -> void:
	if destination != null:
		var world_pos: Vector2 = tile_map.map_to_local(destination)
		var rect: Rect2 = Rect2(world_pos, cell_size)
		draw_rect(rect, Color(1, 0, 0, 1), false, 1)
