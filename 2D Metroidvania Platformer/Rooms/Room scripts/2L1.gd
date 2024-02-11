extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_2L1_body_entered(body):
	body.call_deferred("collisionOnOff", "2L1", get_parent())
