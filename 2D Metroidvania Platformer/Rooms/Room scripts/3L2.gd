extends Area2D


func _ready():
	pass


func _on_3L2_body_entered(body):
	body.call_deferred("collisionOnOff", "3L2", get_parent())
