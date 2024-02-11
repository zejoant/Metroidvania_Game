extends Area2D


func _ready():
	pass


func _on_4L2_body_entered(body):
	body.call_deferred("collisionOnOff", "4L2", get_parent())
