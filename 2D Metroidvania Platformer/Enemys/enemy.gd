extends KinematicBody2D


var health = 2

var gravity =  10
var velocity = Vector2(0, 0)

var speed = 32
var speedMem = 32

var knockbackPower = 50
var knockbackTime = 5

func _ready():
	$AnimationPlayer.play("Enemy move")
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")

func _process(_delta):
	move_character()
	detect_turn_around()
		
func move_character():
	
	velocity.x = speed
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	

func detect_turn_around():
	if (not $RayCast2D.is_colliding() or $RayCast2D2.is_colliding()) and is_on_floor():
		speed = -speed
		speedMem = speed
		scale.x = -scale.x

func takeDamage(damage):
	health -= damage
	speedMem = speed
	if get_tree().get_root().get_node("Map/Player").position.x > position.x:
		speed = -128
	else:
		speed = 128
	velocity.y = -80
	$AnimationPlayer.play("Hurt")
	$Timer.start()

func timerEnd():
	$AnimationPlayer.play("Enemy move")
	speed = speedMem
	if health <= 0:
		var obj = preload("res://Enemys/Poof.tscn").instance()
		obj.position = position
		get_parent().call_deferred("add_child", obj)
		if rand_range(0, 100)>=75:
			var obj2 = preload("res://PowerUps/Heal.tscn").instance()
			obj2.position = position
			get_parent().call_deferred("add_child", obj2)
		queue_free()

func _on_Area2D_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)
	pass # Replace with function body.


