extends KinematicBody2D

var dir = Vector2.UP 
var bullet = preload("res://Enemys/EnemyBullet.tscn")
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	if self.rotation_degrees == 0:
		dir = Vector2.LEFT
	elif self.rotation_degrees == 180:
		dir = Vector2.RIGHT
	elif self.rotation_degrees == 90:
		dir = Vector2.UP
	else:
		dir = Vector2.DOWN


# warning-ignore:unused_argument
func _physics_process(delta):
	time += 1
	if time > 127:
		$AnimationPlayer.play("Shoot")
	if time > 150:
		time = 0
		shoot()

func shoot():
	
	var obj = bullet.instance()
	obj.position = position
	obj.dir = dir
	get_tree().get_root().call_deferred("add_child", obj)
