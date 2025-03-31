extends CharacterBody2D

#ONREADY VARIABLES----------------------------------------------------------------------------------
@onready var tile_map = $"../Ground"
@onready var obstacle_map = $"../Obstacles"
@onready var animation_player = $AnimationPlayer
@onready var player_sprite = $Sprite2D
@onready var cell_size: int = 64

#VARIABLES------------------------------------------------------------------------------------------
var astar_grid = AStarGrid2D.new()
var canMove = true
var movePoints
var current_id_path:Array[Vector2i]
var not_moving = true

#SIGNALS--------------------------------------------------------------------------------------------
signal destination_updated(new_destination)

func _ready() -> void:
	animation_player.play("idle")
	#creating AStarGrid2D object for 2d-grid pathfinding
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(cell_size, cell_size)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	#getting the minimal size rectangle that encompasses all cells of the obstacle tilemaplayer
	var obs_used_rect = obstacle_map.get_used_rect()
	
	#looping through each position in the obstacle rectangle with nested for-loop
	for x in range(obs_used_rect.position.x, obs_used_rect.position.x + obs_used_rect.size.x):
		for y in range(obs_used_rect.position.y, obs_used_rect.position.y + obs_used_rect.size.y):
			#create variable to store each position in rectangle as a Vector2i
			var pos = Vector2i(x, y)
			#creating variable to hold the data of the current obstacle_data cell
			var obstacle_data = obstacle_map.get_cell_tile_data(pos)

			#if there's no data in the current cell and the cell isn't walkable
			if obstacle_data and obstacle_data.get_custom_data("not_walkable") == true:
				#set current obstacle_map coordinates to solid inside of astar_grid
				#this way we don't use it in any calculations for pathfinding, so character 'moves around' this point
				astar_grid.set_point_solid(pos)

#MOVEMENT SYSTEM------------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	#if we press left click, our player is able to move, and the next tile isn't a barrier, move there
	if event.is_action_pressed("left_click") == false or canMove == false:
		return
	move()
		
func move():
	if movePoints == 0:
		return
		
	var mousePos = tile_map.local_to_map(get_global_mouse_position())
	var id_path = astar_grid.get_id_path(tile_map.local_to_map(global_position),mousePos).slice(1)

	print(id_path)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
		var last_destination = current_id_path[current_id_path.size()-1]
		emit_signal("destination_updated", last_destination)
	
func _physics_process(delta):
	if current_id_path.is_empty():
		animation_player.play("idle")
		return
		
	var current_animation = animation_player.current_animation		
	var target_position = tile_map.map_to_local(current_id_path.front())
	
	#if we're idling, we need to switch to running in next AStarGrid2D direction relative to our current position
	if(current_animation == "idle"):
		if global_position.x < target_position.x:
			$AnimationPlayer.play("run")
		elif global_position.x > target_position.x:
			$AnimationPlayer.play("run")
		elif global_position.y < target_position.y:
			$AnimationPlayer.play("run")
		elif global_position.y > target_position.y:
			$AnimationPlayer.play("run")
			
	global_position = global_position.move_toward(target_position, 2)
	if global_position == target_position:
		current_id_path.pop_front()
#END------------------------------------------------------------------------------------------------

#PLAYER ATTRIBUTES----------------------------------------------------------------------------------
var player_class
var current_health = 100
var max_health
var current_stamina
var max_stamina
#END------------------------------------------------------------------------------------------------

#UTILITY FUNCTIONS ---------------------------------------------------------------------------------
