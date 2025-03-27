extends Camera2D

@export var smoothing_speed: float = 50
var target: Node2D

func _ready():
	target = $"../Player/AnimatedSprite2D"
	
func _process(delta: float) -> void:
	followCharacter(delta)
		
func followCharacter(delta):
	if target:
		# Smoothly move the camera toward the target's position
		position = position.move_toward(target.global_position, smoothing_speed * delta)
