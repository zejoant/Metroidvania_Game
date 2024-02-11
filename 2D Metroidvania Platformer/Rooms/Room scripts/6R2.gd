extends Area2D


func _ready():
	pass


func _on_6R2_body_entered(body):
	body.call_deferred("collisionOnOff", "6R2", get_parent())
