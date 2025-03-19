extends CharacterBody2D

@onready var tile_map = $"../TileMapLayer"
@onready var sprite_2d = $AnimatedSprite2D

var is_moving = false

func _ready():
	animate()

func _physics_process(delta: float) -> void:
	if is_moving == false:
		return

	if global_position == sprite_2d.global_position:
		is_moving = false
		return

	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 2)

func _process(delta: float) -> void:
	if is_moving:
		return

	if Input.is_action_pressed("ui_down"):
		move(Vector2i.DOWN)
	elif Input.is_action_pressed("ui_up"):
		move(Vector2i.UP)
	elif Input.is_action_pressed("ui_right"):
		move(Vector2i.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		move(Vector2i.LEFT)

func move(direction: Vector2):
	#setting the coordinates of the tile relative to the current global position of the player
	#(global_position refers to the current global grid position of the node this script is attached to)
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	#after we get current tile, we will determine the coordinates of the tile we want to move to
	#this is calculated by adding the passed coordinates of the direction vector to the current tiles vector
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)

	#after we get coordinates for next tile, we will get the target tiles attributes
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)

	#if there is no data collected from the target tile, we get null
	if tile_data == null:
		return

	#if tile isn't walkable, then we don't allow the character to walk on it and we exit
	if tile_data.get_custom_data("walkable") == false:
		return

	is_moving = true

	#if we don't exit, we set the global position of the character to the new target tile's coordinates
	global_position = tile_map.map_to_local(target_tile)
	sprite_2d.global_position = tile_map.map_to_local(current_tile)

func animate():
	sprite_2d.play("idle")
