extends Area2D
var dir
var bulletDamage = 1


# warning-ignore:unused_argument
func _physics_process(delta):
	position += dir


func _on_BulletColl_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(bulletDamage)
	queue_free()



func _on_EnemyBullet_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(bulletDamage, false, position, 50, 5)
	queue_free()
