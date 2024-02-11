extends KinematicBody2D

var speed = Vector2(-110, 0)
var knockbackPower = 50
var knockbackTime = 5
var health = 2

func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")

func _process(_delta):
	if !is_on_floor():
		speed.y += 8
	else:
		speed.y = (speed.y-speed.y/8)*-1
	if is_on_wall():
		speed.x *= -1
		scale.x *= -1
		#position.x += speed.x/abs(speed.x)
	move_character()
		
func move_character():
# warning-ignore:return_value_discarded
	move_and_slide(speed, Vector2.UP)
	rotation -= PI/8

func _on_DamageArea_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)

func takeDamage(damage):
	health -= damage
	var player = get_tree().get_root().get_node("Map/Player")
	if player.dashDir == 1 and speed.x < 0 or player.dashDir == -1 and speed.x > 0:
		speed.x *= -1
		scale.x *= -1
	$Timer.start()

func timerEnd():
	if health <= 0:
		var obj = preload("res://Enemys/Poof.tscn").instance()
		obj.position = position
		get_parent().call_deferred("add_child", obj)
		if rand_range(0, 100)>=75:
			var obj2 = preload("res://PowerUps/Heal.tscn").instance()
			obj2.position = position
			get_parent().call_deferred("add_child", obj2)
		queue_free()
