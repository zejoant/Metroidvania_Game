extends KinematicBody2D

var acceleration = 0.5
var ySpeed = -500
var xSpeed = 0
var health = 3
var speedMem = 0.6

var knockbackPower = 50
var knockbackTime = 5

func _ready():
# warning-ignore:return_value_discarded
	 $Timer.connect("timeout",self,"timerEnd")

# warning-ignore:unused_argument
func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(Vector2(xSpeed, 0))
	if ySpeed != -500:
# warning-ignore:return_value_discarded
		move_and_collide(Vector2(0, ySpeed))
		ySpeed += acceleration
	if ySpeed >= 0:
		get_node("DetectGround").disabled = false
	
	if ySpeed >= 5:
		acceleration = 0
		ySpeed = 3
	if !is_on_floor():
		acceleration = 0.5
	
	if $RayCast2D.get_collider() and ySpeed != -500:
		xSpeed = -xSpeed
		speedMem = xSpeed
		scale.x = -scale.x
		
func _on_Player_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)
		

func takeDamage(damage):
	health -= damage
	speedMem = xSpeed
	if get_tree().get_root().get_node("Map/Player").position.x > position.x:
		xSpeed = -1.5
	else:
		xSpeed = 1.5	
	ySpeed = -3
	$AnimationPlayer2.play("Damage")
	$Timer.start()

func timerEnd():
	xSpeed = speedMem
	if health <= 0:
		var obj2 = preload("res://Enemys/Poof.tscn").instance()
		obj2.position = position
		get_parent().call_deferred("add_child", obj2)
		if rand_range(0, 100)>=75:
			var obj = preload("res://PowerUps/Heal.tscn").instance()
			obj.position = position
			get_parent().call_deferred("add_child", obj)
		queue_free()

func _on_Detector_body_exited(body):
	if ySpeed == -500:
		ySpeed = -5
		if body.position.x - position.x < 0:
			xSpeed = 0.6
		else:
			xSpeed = -0.6
			scale.x = -scale.x
		$AnimationPlayer.play("walk")





