extends Area2D


func _ready():
	pass


func _on_2L2_body_entered(body):
	body.call_deferred("collisionOnOff", "2L2", get_parent())	
