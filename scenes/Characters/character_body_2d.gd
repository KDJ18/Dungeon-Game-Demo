extends CharacterBody2D

@onready var animation:AnimationPlayer = $AnimationPlayer
@onready var target = $"../Player"
var speed = 150

func _ready() -> void:
	animation.play("goonidle")
	
func _physics_process(delta: float) -> void:
	var direction=(target.position-position).normalized()
	velocity=direction*speed
	look_at(target.position)
	move_and_slide
	
