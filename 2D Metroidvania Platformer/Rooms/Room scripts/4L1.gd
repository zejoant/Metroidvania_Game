extends Area2D


func _ready():
	pass


func _on_4L1_body_entered(body):
	body.call_deferred("collisionOnOff", "4L1", get_parent())
