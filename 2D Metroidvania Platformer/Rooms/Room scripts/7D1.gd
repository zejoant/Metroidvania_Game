extends Area2D


func _ready():
	pass


func _on_7D1_body_entered(body):
	body.call_deferred("collisionOnOff", "7D1", get_parent())
