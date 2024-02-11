extends Area2D


func _ready():
	pass


func _on_5R2_body_entered(body):
	body.call_deferred("collisionOnOff", "5R2", get_parent())
