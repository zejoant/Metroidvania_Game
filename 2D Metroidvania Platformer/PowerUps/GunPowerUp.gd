extends Area2D


func _ready():
	pass


func _on_GunPowerUp_body_entered(body):
	if body.has_method("GunNar"):
		body.GunNar()
		queue_free()


