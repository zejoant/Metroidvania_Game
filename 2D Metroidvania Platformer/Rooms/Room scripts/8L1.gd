extends Area2D


func _ready():
	pass


func _on_8L1_body_entered(body):
	body.call_deferred("collisionOnOff", "8L1", get_parent())
