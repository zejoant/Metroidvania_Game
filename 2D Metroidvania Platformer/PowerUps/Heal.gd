extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	pass # Replace with function body.



func _on_Heal_body_entered(body):
	if body.has_method("heal"):
		body.heal()
		queue_free()
