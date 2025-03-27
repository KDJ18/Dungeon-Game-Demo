extends Node2D

#we're going to have methods in this that are very general
#we will manipulate parent's attributes in this script. health, stamina, mana, etc...
var character
var current_health
var max_health
var current_stamina
var max_stamina

func _ready() -> void:
	#only start managing stats if parent is created
	character = get_parent()
	if character:
		get_character_data()

func get_character_data():
	current_health = character.current_health
	max_health = character.max_health
	current_stamina = character.current_stamina
	max_stamina = character.max_stamina
	print("Current Player Health: ", current_health)
	
func regenerate_stats():
	#completely refill stats for parent character
	character.current_health = max_health
	character.current_stamina = max_stamina
