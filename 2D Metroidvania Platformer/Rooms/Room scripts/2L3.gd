extends Area2D


func _ready():
	pass


func _on_2L3_body_entered(body):
	body.call_deferred("collisionOnOff", "2L3", get_parent())
