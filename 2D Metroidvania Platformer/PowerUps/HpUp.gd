extends Area2D


func _on_HpUp_body_entered(body):
	if body.has_method("hpUp"):
		body.hpUp()
		queue_free()
