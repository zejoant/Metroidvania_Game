extends KinematicBody2D

var speed = Vector2(-50, -300)
var speedMem = speed

var knockbackPower = 50
var knockbackTime = 5

var health = 5

func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(speed, Vector2.UP)
	speed.y += 10

	if is_on_floor():
		speed.y = -300
		$AnimationPlayer.play("Bounce")
	if is_on_ceiling():
		speed.y = 1
	if is_on_wall():
		speed.x *= -1
		scale.x *= -1
		position.x += speed.x/abs(speed.x)


func _on_Damage_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)

func takeDamage(damage):
	health -= damage
	speedMem.x = speed.x
	if position.x > get_tree().get_root().get_node("Map/Player").position.x:
		speed.x = 100
	else:
		speed.x = -100
	
	if position.y < get_tree().get_root().get_node("Map/Player").position.y:
		speed.y = -200
	else:
		speed.y += 200
	
	#$AnimationPlayer.play("Hurt")
	$Timer.start()

func timerEnd():
	#$AnimationPlayer.play("Enemy move")
	speed.x = speedMem.x
	if health <= 0:
		var obj = preload("res://Enemys/Poof.tscn").instance()
		obj.position = position
		get_parent().call_deferred("add_child", obj)
		if rand_range(0, 100)>=75:
			var obj2 = preload("res://PowerUps/Heal.tscn").instance()
			obj2.position = position
			get_parent().call_deferred("add_child", obj2)
		queue_free()
