extends Area2D


func _ready():
	pass


func _on_5R1_body_entered(body):
	body.call_deferred("collisionOnOff", "5R1", get_parent())
