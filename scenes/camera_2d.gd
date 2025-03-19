extends Camera2D

@export var smoothing_speed: float = 50  # Adjust this value for smoothness (e.g., 200 for faster movement)
var target: Node2D  # The object the camera will follow (e.g., the player)

func _ready():
	target = $"../Player/AnimatedSprite2D"  # Adjust this to point to your player or desired target
	
func _process(delta: float) -> void:
	followCharacter(delta)
		
func followCharacter(delta):
	if target:
		# Smoothly move the camera toward the target's position
		position = position.move_toward(target.global_position, smoothing_speed * delta)
