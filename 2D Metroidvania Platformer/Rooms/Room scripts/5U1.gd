extends Area2D


func _ready():
	pass


func _on_5U1_body_entered(body):
	body.call_deferred("collisionOnOff", "5U1", get_parent())
