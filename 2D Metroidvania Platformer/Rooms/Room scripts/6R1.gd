extends Area2D


func _ready():
	pass


func _on_6R1_body_entered(body):
	body.call_deferred("collisionOnOff", "6R1", get_parent())
