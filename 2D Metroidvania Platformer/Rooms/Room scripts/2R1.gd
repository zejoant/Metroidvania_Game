extends Area2D

func _ready():
	pass

func _on_2R1_body_entered(body):
	body.call_deferred("collisionOnOff", "2R1", get_parent())
