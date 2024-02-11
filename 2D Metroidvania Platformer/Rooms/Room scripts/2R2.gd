extends Area2D

func _ready():
	pass # Replace with function body.

func _on_2R2_body_entered(body):
	body.call_deferred("collisionOnOff", "2R2", get_parent())
