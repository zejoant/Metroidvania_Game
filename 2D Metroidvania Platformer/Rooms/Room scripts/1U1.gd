extends Area2D


func _ready():
	pass


func _on_1U1_body_entered(body):
	body.call_deferred("collisionOnOff", "1U1", get_parent())
