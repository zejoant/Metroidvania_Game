extends KinematicBody2D
var dir
var bulletDamage = 0.5

func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")
	$Timer.start()

# warning-ignore:unused_argument
func _physics_process(delta):
	position += dir

func timerEnd():
	queue_free()


func _on_BulletColl_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(bulletDamage)
	queue_free()

