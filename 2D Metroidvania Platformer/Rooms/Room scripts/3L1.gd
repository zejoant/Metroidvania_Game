extends Area2D


func _ready():
	pass


func _on_3L1_body_entered(body):
	body.call_deferred("collisionOnOff", "3L1", get_parent())
