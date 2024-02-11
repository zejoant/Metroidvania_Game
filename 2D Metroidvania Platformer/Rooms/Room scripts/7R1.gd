extends Area2D


func _ready():
	pass


func _on_7R1_body_entered(body):
	body.call_deferred("collisionOnOff", "7R1", get_parent())
