extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_DoubleJump_body_entered(body):
	if body.has_method("doubleJump"):
		body.doubleJump()
		queue_free()
