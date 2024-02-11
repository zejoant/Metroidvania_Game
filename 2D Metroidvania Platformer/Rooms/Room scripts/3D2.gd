extends Area2D


func _ready():
	pass


func _on_3D1_body_entered(body):
	body.call_deferred("collisionOnOff", "3D1", get_parent())
